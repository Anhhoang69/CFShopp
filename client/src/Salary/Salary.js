import React, { Component } from "react";
import { Link } from "react-router-dom";

class EmployeeSalaryReport extends Component {
  constructor(props) {
    super(props);
    this.state = {
      shopID: "",
      startDate: "",
      endDate: "",
      salaries: [], // Dữ liệu kết quả trả về
    };
  }

  handleInputChange = (event) => {
    const { name, value } = event.target;
    this.setState({ [name]: value });
  };

  handleSearch = () => {
    const { shopID, startDate, endDate } = this.state;

    // Hardcode dữ liệu giả lập thay cho việc gọi API/database
    const mockData = [
      { empID: "E001", empName: "Nguyen Van A", Salary: 5000000 },
      { empID: "E002", empName: "Tran Thi B", Salary: 4500000 },
      { empID: "E003", empName: "Le Van C", Salary: 6000000 },
    ];

    // Kiểm tra dữ liệu đầu vào
    if (shopID.length !== 5) {
      this.setState({
        salaries: [
          {
            empID: "ERROR",
            empName: "ID cửa hàng không đúng định dạng",
            Salary: null,
          },
        ],
      });
      return;
    }

    if (startDate > endDate) {
      this.setState({
        salaries: [
          {
            empID: "ERROR",
            empName: "Lỗi thời gian",
            Salary: null,
          },
        ],
      });
      return;
    }

    if (shopID !== "CF001") {
      this.setState({
        salaries: [
          {
            empID: "ERROR",
            empName: "Cửa hàng không tồn tại",
            Salary: null,
          },
        ],
      });
      return;
    }

    // Giả lập lọc dữ liệu từ khoảng thời gian và ShopID
    const filteredData = mockData.filter((item) => shopID === "CF001");
    this.setState({ salaries: filteredData });
  };

  render() {
    const { shopID, startDate, endDate, salaries } = this.state;

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
