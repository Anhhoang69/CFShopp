import React, { Component } from "react";
import { Link } from "react-router-dom";
import axios from "axios";

class EmployeeSalaryReport extends Component {
  constructor(props) {
    super(props);
    this.state = {
      shopID: "",
      startDate: "",
      endDate: "",
      salaries: [], // Dữ liệu kết quả trả về
      error: "", // Lỗi nếu có trong quá trình gọi API
    };
  }

  handleInputChange = (event) => {
    const { name, value } = event.target;
    this.setState({ [name]: value });
  };

  handleSearch = async () => {
    const { shopID, startDate, endDate } = this.state;

    // Kiểm tra dữ liệu đầu vào
    if (shopID.length !== 5) {
      this.setState({
        salaries: [],
        error: "ID cửa hàng không đúng định dạng",
      });
      return;
    }

    if (startDate > endDate) {
      this.setState({
        salaries: [],
        error: "Lỗi thời gian",
      });
      return;
    }


    try {
      // Gửi yêu cầu POST đến API backend với tham số shopID, startDate, endDate
      const response = await axios.post("http://localhost:5000/calculate-salaries", {
        shopID,
        startDate,
        endDate,
      });

      // Lưu kết quả vào state
      this.setState({
        salaries: response.data,
        error: "",
      });
    } catch (error) {
      console.error("Error fetching data:", error);
      this.setState({
        salaries: [],
        error: "Có lỗi khi tính lương, vui lòng thử lại!",
      });
    }
  };


  render() {
    const { shopID, startDate, endDate, salaries, error } = this.state;

    return (
      <div className="container">
        <h1>Báo cáo lương nhân viên theo cửa hàng</h1>

        {/* Form nhập liệu */}
        <div className="form-group">
          <label htmlFor="shopID">Mã ShopID:</label>
          <input
            type="text"
            id="shopID"
            name="shopID"
            value={shopID}
            className="form-control"
            onChange={this.handleInputChange}
            placeholder="Nhập mã ShopID"
          />
        </div>

        <div className="form-group">
          <label htmlFor="startDate">Ngày bắt đầu:</label>
          <input
            type="date"
            id="startDate"
            name="startDate"
            value={startDate}
            className="form-control"
            onChange={this.handleInputChange}
          />
        </div>

        <div className="form-group">
          <label htmlFor="endDate">Ngày kết thúc:</label>
          <input
            type="date"
            id="endDate"
            name="endDate"
            value={endDate}
            className="form-control"
            onChange={this.handleInputChange}
          />
        </div>

        <button className="btn btn-primary" onClick={this.handleSearch}>
          Tìm kiếm
        </button>
        &nbsp;
        <Link to="/list-employees" className="btn btn-secondary">
          Quay về
        </Link>

        {/* Hiển thị lỗi nếu có */}
        {error && <div className="alert alert-danger mt-3">{error}</div>}

        {/* Bảng kết quả */}
        {salaries.length > 0 && (
          <div className="mt-4">
            <h2>Kết quả báo cáo:</h2>
            <table className="table table-bordered">
              <thead>
                <tr>
                  <th>ID Nhân viên</th>
                  <th>Tên Nhân viên</th>
                  <th>Lương</th>
                </tr>
              </thead>
              <tbody>
                {salaries.map((salary, index) => (
                  <tr key={index}>
                    <td>{salary.empID}</td>
                    <td>{salary.empName}</td>
                    <td>{salary.Salary !== null ? `${salary.Salary.toLocaleString()} VND` : ""}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    );
  }
}

export default EmployeeSalaryReport;
