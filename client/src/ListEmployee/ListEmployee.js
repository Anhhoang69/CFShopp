/* eslint-disable react/style-prop-object */ 
/* eslint-disable jsx-a11y/anchor-is-valid */
import React, { Component } from "react";
import "./ListEmployee.css";
import ListNV from "./Components/ListNV";
import { Link } from "react-router-dom";

class ListEmployee extends Component {
  constructor(props) {
    super(props);
    this.state = {
      employees: [
        {
          _id: "1",
          empID: "E001",
          empName: "Nguyen Van A",
          empPhoneNumber: "0123456789",
          empSex: "Nam",
          empType: "Phục vụ",
          serPosition: "Bàn 1",
          delLicense: "N/A",
          shopID: "CF001",
          empAddress: "123 Đường ABC",
          empEmail: "nguyenvana@example.com",
          hourSalary: 50,
          empStatus: "Active",
        },
        {
          _id: "2",
          empID: "E002",
          empName: "Tran Thi B",
          empPhoneNumber: "0987654321",
          empSex: "Nữ",
          empType: "Giao hàng",
          serPosition: "N/A",
          delLicense: "B2",
          shopID: "CF002",
          empAddress: "456 Đường DEF",
          empEmail: "tranthib@example.com",
          hourSalary: 55,
          empStatus: "Inactive",
        },
        {
          _id: "3",
          empID: "E003",
          empName: "Le Van C",
          empPhoneNumber: "0912345678",
          empSex: "Nam",
          empType: "Thu ngân",
          serPosition: "N/A",
          delLicense: "N/A",
          shopID: "CF003",
          empAddress: "789 Đường GHI",
          empEmail: "levanc@example.com",
          hourSalary: 60,
          empStatus: "On Leave",
        },
        {
          _id: "4",
          empID: "E004",
          empName: "Pham Thi D",
          empPhoneNumber: "0908765432",
          empSex: "Nữ",
          empType: "Quản lý",
          serPosition: "N/A",
          delLicense: "N/A",
          shopID: "CF001",
          empAddress: "123 Đường XYZ",
          empEmail: "phamthid@example.com",
          hourSalary: 80,
          empStatus: "Active",
        },
        {
          _id: "5",
          empID: "E005",
          empName: "Hoang Van E",
          empPhoneNumber: "0901234567",
          empSex: "Nam",
          empType: "Giao hàng",
          serPosition: "N/A",
          delLicense: "A1",
          shopID: "CF002",
          empAddress: "234 Đường KLM",
          empEmail: "hoangvane@example.com",
          hourSalary: 40,
          empStatus: "Suspended",
        },
        {
          _id: "6",
          empID: "E006",
          empName: "Ngo Thi F",
          empPhoneNumber: "0986543210",
          empSex: "Nữ",
          empType: "Phục vụ",
          serPosition: "Bàn 3",
          delLicense: "N/A",
          shopID: "CF003",
          empAddress: "567 Đường OPQ",
          empEmail: "ngothif@example.com",
          hourSalary: 45,
          empStatus: "Active",
        },
        {
          _id: "7",
          empID: "E007",
          empName: "Nguyen Van G",
          empPhoneNumber: "0922334455",
          empSex: "Nam",
          empType: "Thu ngân",
          serPosition: "N/A",
          delLicense: "N/A",
          shopID: "CF004",
          empAddress: "678 Đường RST",
          empEmail: "nguyenvang@example.com",
          hourSalary: 65,
          empStatus: "Active",
        },
      ],
      filteredEmployees: [],
      inputShopID: "", // Giá trị nhập vào của shopID
    };
  }

  onSearch = () => {
    const { employees, inputShopID } = this.state;
    const filteredEmployees = employees.filter(
      (employee) => employee.shopID === inputShopID
    );
    this.setState({ filteredEmployees });
  };

  onDelete = (_id) => {
    const updatedEmployees = this.state.employees.filter(
      (employee) => employee._id !== _id
    );
    const updatedFilteredEmployees = this.state.filteredEmployees.filter(
      (employee) => employee._id !== _id
    );
    this.setState({ employees: updatedEmployees, filteredEmployees: updatedFilteredEmployees });
  };

  handleInputChange = (event) => {
    this.setState({ inputShopID: event.target.value });
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
              <ListNV employees={filteredEmployees} onDelete={this.onDelete} />
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default ListEmployee;
