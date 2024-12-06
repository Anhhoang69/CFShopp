/* eslint-disable react/style-prop-object */ 
/* eslint-disable jsx-a11y/anchor-is-valid */
import React, { Component } from "react";
import axios from "axios";
import "./ListEmployee.css";
import ListNV from "./Components/ListNV";
import { Link } from "react-router-dom";

class ListEmployee extends Component {
  constructor(props) {
    super(props);
    this.state = {
      employees: [],
      filteredEmployees: [],
      inputShopID: "", // Giá trị nhập vào của shopID
      deleteError: {},
    };
  }
  onSearch = async () => {
    const { inputShopID } = this.state;
  
    if (!inputShopID) {
      alert("Vui lòng nhập ShopID!");
      return;
    }
  
    try {
      const response = await axios.get(
        `http://localhost:5000/employees/${inputShopID}` 
      );
  
      const employeesWithUpdatedGender = response.data.map((employee) => {
        return {
          ...employee,
          empSex: employee.empSex === "M" ? "Nam" : employee.empSex === "F" ? "Nữ" : employee.empSex,
        };
      });
  
      this.setState({
        filteredEmployees: employeesWithUpdatedGender,
      });
    } catch (error) {
      console.error("Error fetching data:", error);
      alert("Không thể lấy danh sách nhân viên!");
    }
  };
  
  onDelete = async (empID) => {
    try {
      await axios.delete("http://localhost:5000/delete-employee", {
        data: { empID },
      });
  
      alert("Xóa nhân viên thành công!");
      this.setState((prevState) => ({
        filteredEmployees: prevState.filteredEmployees.filter(
          (employee) => employee.empID !== empID
        ),
        deleteError: { ...prevState.deleteError, [empID]: "" },
      }));
    } catch (error) {
      const errorMsg =
        error.response?.data?.error || "Có lỗi xảy ra khi xóa nhân viên!";
      console.log(`Lỗi khi xóa nhân viên ${empID}:`, errorMsg); // Kiểm tra lỗi
      this.setState((prevState) => ({
        deleteError: {
          ...prevState.deleteError,
          [empID]: errorMsg,
        },
      }));
    }
  };
  
  
  
  // Hàm để reset lỗi khi người dùng đóng thông báo lỗi
  dismissError = (empID) => {
    this.setState((prevState) => ({
      deleteError: {
        ...prevState.deleteError,
        [empID]: "", // Xóa lỗi của nhân viên cụ thể
      },
    }));
  };
  
  
  
  
  handleInputChange = (event) => {
    this.setState({
      inputShopID: event.target.value,
    });
  };
  
  render() {
    const { filteredEmployees, inputShopID } = this.state;
    return (
      <div className="Container">
        <div className="text_center">
          <h1 id="qlnv">Quản lý nhân viên</h1>
        </div>
        <div className="col-xs-12 col-sm-12 col-md-12 col-lg-12">
          &nbsp;
          <div className="row mb-3">
            <div className="col-md-6">
              <input
                type="text"
                className="form-control"
                placeholder="Nhập ShopID"
                value={inputShopID}
                onChange={this.handleInputChange}
              />
            </div>
            <div className="col-md-2">
              <button
                className="btn btn-primary"
                onClick={this.onSearch}
              >
                Tìm kiếm
              </button>
            </div>
          </div>
          <Link to="/list-employees/add" className="btn btn-primary custom">
            <span className="fa fa-plus"></span> &nbsp; Thêm nhân viên
          </Link>{" "}
          <Link to="/list-employees/salary" className="btn btn-primary custom">
             Tính lương
          </Link>{" "}
          <div className="row">
            <div className="col-xs-12 col-sm-12 col-md-12 col-lg-12">
            <ListNV
                employees={filteredEmployees}
                onDelete={this.onDelete}
                deleteError={this.state.deleteError}
                dismissError={this.dismissError}
              />

            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default ListEmployee;
