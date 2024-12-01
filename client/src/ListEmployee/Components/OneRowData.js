import React, { Component } from "react";
import { Link } from "react-router-dom";
import "./modal.css";
import Modal from "react-modal"; // Cài đặt thư viện react-modal nếu chưa có

class OneRowData extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isModalOpen: false,
      employeeData: {},
    };
  }

  onDelete = (empID) => {
    if (window.confirm("Bạn chắc chắn muốn xóa nhân viên này?")) {
      this.props.onDelete(empID);
    }
  };

  openModal = () => {
    this.setState({ isModalOpen: true });
  };

  closeModal = () => {
    this.setState({ isModalOpen: false });
  };

  handleInputChange = (e) => {
    const { name, value } = e.target;
    this.setState((prevState) => ({
      employeeData: {
        ...prevState.employeeData,
        [name]: value,
      },
    }));
  };

  handleFormSubmit = (e) => {
    e.preventDefault();
    const { employeeData } = this.state;
    // Gọi hàm từ component cha để xử lý cập nhật dữ liệu (có thể truyền qua props)
    this.props.onUpdate(employeeData);
    this.closeModal();
  };

  componentDidMount() {
    const { employee } = this.props;
    this.setState({ employeeData: { ...employee } });
  }

  render() {
    const { employee, index } = this.props;
    const { isModalOpen, employeeData } = this.state;

    return (
      <tr height="30px">
        <td className="text_center">{index + 1}</td>
        <td className="text_center">{employee.empID}</td>
        <td>{employee.empName}</td>
        <td className="text_center">{employee.empPhoneNumber}</td>
        <td className="text_center">{employee.empSex}</td>
        <td>{employee.empAddress}</td>
        <td>{employee.empEmail}</td>
        <td className="text_center">{employee.hourSalary}</td>
        <td className="text_center">{employee.empStatus}</td>

        <td className="text_center">{employee.empType}</td>
        <td className="text_center">
          {employee.empType === "Phục vụ"
            ? employee.serPosition || "N/A"
            : "N/A"}
        </td>
        <td className="text_center">
          {employee.empType === "Giao hàng"
            ? employee.delLicense || "N/A"
            : "N/A"}
        </td>
        <td className="text_center">
          <Link
            to="#"
            className="btn btn-warning"
            onClick={this.openModal}
          >
            <span className="fa fa-info"></span> &nbsp;Sửa
          </Link>{" "}
          &nbsp;
          <button
            className="btn btn-danger"
            type="button"
            onClick={() => this.onDelete(employee._id)}
          >
            <span className="fa fa-trash"></span> &nbsp;Xóa
          </button>{" "}
          &nbsp;
        </td>

        {/* Modal */}
        <Modal
          isOpen={isModalOpen}
          onRequestClose={this.closeModal}
          contentLabel="Update Employee"
          className="ReactModal__Content"
          overlayClassName="ReactModal__Overlay"
        >
          <h2>Cập nhật thông tin nhân viên</h2>
          <form onSubmit={this.handleFormSubmit}>
            <div>
              <label>Tên nhân viên:</label>
              <input
                type="text"
                name="empName"
                value={employeeData.empName || ""}
                onChange={this.handleInputChange}
                required
              />
            </div>
            <div>
              <label>Số điện thoại:</label>
              <input
                type="text"
                name="empPhoneNumber"
                value={employeeData.empPhoneNumber || ""}
                onChange={this.handleInputChange}
                required
              />
            </div>
            <div>
              <label>Địa chỉ:</label>
              <input
                type="text"
                name="empAddress"
                value={employeeData.empAddress || ""}
                onChange={this.handleInputChange}
              />
            </div>
            <div>
              <label>Lương trên giờ:</label>
              <input
                type="number"
                name="hourSalary"
                value={employeeData.hourSalary || ""}
                onChange={this.handleInputChange}
              />
            </div>
            <div>
              <label>Trạng thái:</label>
              <select
                name="empStatus"
                value={employeeData.empStatus || ""}
                onChange={this.handleInputChange}
              >
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
                <option value="On Leave">On Leave</option>
                <option value="Suspended">Suspended</option>
              </select>
            </div>
            <div className="button-container">
              <button type="submit" className="btn btn-success">Cập nhật</button>
              <button type="button" className="btn btn-secondary" onClick={this.closeModal}>Đóng</button>
            </div>
          </form>
        </Modal>
      </tr>
    );
  }
}

export default OneRowData;
