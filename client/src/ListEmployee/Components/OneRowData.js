import React, { Component } from "react";
import axios from "axios";
import { Link } from "react-router-dom";
import "./modal.css";
import Modal from "react-modal"; // Cài đặt thư viện react-modal nếu chưa có

class OneRowData extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isModalOpen: false,
      employeeData: {},
      originalEmployeeData: {},
      updateError: null,
      successMessage: null,
    };
  }

  onDelete = () => {
    const { employee, onDelete } = this.props;
    if (window.confirm("Bạn chắc chắn muốn xóa nhân viên này không?")) {
      onDelete(employee.empID); // Gọi hàm xóa từ component cha
    }
  };
  

  openModal = () => {
    this.setState({ isModalOpen: true, updateError: null, successMessage: null });
  };
  

  closeModal = () => {
    this.setState({ isModalOpen: false });
  };

  // Xử lý thay đổi giá trị input
  /*handleInputChange = (e) => {
    const { name, value } = e.target;
    this.setState((prevState) => ({
      employeeData: {
        ...prevState.employeeData,
        [name]: value,
      },
    }));
  };*/
  
  
  componentDidMount() {
    Modal.setAppElement('#root');
    const { employee } = this.props;

    let empEmails = "";
    if (Array.isArray(employee.emailEmp)) {
      // Nếu emailEmp là mảng, chuyển đổi thành chuỗi phân tách bằng dấu phẩy
      empEmails = employee.emailEmp.map(item => item.emailEmp).join(", ");
    } else if (typeof employee.emailEmp === "string") {
      // Nếu emailEmp là chuỗi, giữ nguyên
      empEmails = employee.emailEmp;
    }
    const employeeData = {
      empID: employee.empID,
      empName: employee.empName || "",
      empPhoneNumber: employee.empPhoneNumber || "",
      empAddress: employee.empAddress || "",
      hourSalary: employee.hourSalary || "",
      empStatus: employee.empStatus || "",
      empSex: employee.empSex || "",
      bdate: employee.bdate ? employee.bdate.split("T")[0] : "", // Format ngày để hiển thị
      empAccount: employee.empAccount || "",
      empType: employee.empType || "",
      supervisorID: employee.supervisorID || "",
      empshopID: employee.empshopID || "",
      empEmails: empEmails,
      delLicense: employee.delLicense || "",
      serPosition: employee.serPosition || "",
    };

    this.setState({
      employeeData,
      originalEmployeeData: { ...employeeData }, // Lưu lại giá trị ban đầu
    });
  }
  handleInputChange = (e) => {
    const { name, value } = e.target;

    this.setState((prevState) => ({
      employeeData: {
        ...prevState.employeeData,
        [name]: name === "empSex" ? (value === "Nam" ? "M" : value === "Nữ" ? "F" : "") : value,
      },
    }));
  };
  handleFormSubmit = async (e) => {
    e.preventDefault();
    const { employeeData, originalEmployeeData } = this.state;
    console.log("EmpID trước khi gửi:", employeeData.empID);

    const updatedEmployeeData = {
      empID: employeeData.empID, // Đảm bảo empID luôn được gửi đi
    };
    Object.keys(employeeData).forEach((key) => {
      if (employeeData[key] !== this.state.originalEmployeeData[key]) {
        updatedEmployeeData[key] = employeeData[key];
      }
    });

    // So sánh với dữ liệu ban đầu và chỉ gửi các trường có sự thay đổi
   
    if (Object.keys(updatedEmployeeData).length === 1) {
      // Nếu không có trường nào thay đổi
      alert("Không có thay đổi nào.");
      return;
    }

    console.log("Data gửi lên API:", updatedEmployeeData);

    try {
      const response = await axios.post("http://localhost:5000/update-employee", updatedEmployeeData);
      this.setState({ successMessage: response.data.message, updateError: null });
      this.closeModal(); // Đóng modal sau khi cập nhật thành công
      this.props.refreshData(); // Gọi hàm làm mới dữ liệu từ component cha
    } catch (error) {
      this.setState({
        updateError: error.response?.data?.error || "Có lỗi xảy ra khi cập nhật.",
        successMessage: null,
      });
    }
  };
  
  render() {
    const { employee, index } = this.props;
    const { isModalOpen, employeeData, updateError, successMessage } = this.state;

    let emails = [];
  if (typeof employeeData.empEmails === "string") {
    emails = employeeData.empEmails.split(", ").map(email => email.trim());  // Tách chuỗi email thành mảng
  } else if (Array.isArray(employeeData.empEmails)) {
    emails = employeeData.empEmails;  // Nếu đã là mảng, không cần xử lý thêm
  }
    
    return (
      <tr height="30px">
        <td className="text_center">{index + 1}</td>
        <td className="text_center">{employee.empID}</td>
        <td>{employee.empName}</td>
        <td className="text_center">{employee.empPhoneNumber}</td>
        <td className="text_center">{employee.empSex}</td>
        <td>{employee.empAddress}</td>
        <td>{emails.length > 0 ? (
        <ul className="no-bullets">
          {employeeData.empEmails.split(", ").map((email, index) => (  // Chia chuỗi và hiển thị từng email
            <li key={index}>{email}</li>
          ))}
        </ul>
      ) : (
        <p>N/A</p>
      )}</td>
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
            onClick={() => this.onDelete(employee.empID)}
          >
            <span className="fa fa-trash"></span> &nbsp;Xóa
          </button>{" "}
          &nbsp;
        </td>
        {this.props.deleteError && (
        <tr>
          <td colSpan="12" onClick={this.props.dismissError}>
            <div className="alert alert-danger">
              {this.props.deleteError}
              <span style={{ cursor: "pointer", marginLeft: "10px" }}>
                &times;
              </span>
            </div>
          </td>
        </tr>
      )}
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
                value={employeeData.empName}
                onChange={this.handleInputChange}
              />
            </div>
            <div>
              <label>Số điện thoại:</label>
              <input
                type="text"
                name="empPhoneNumber"
                value={employeeData.empPhoneNumber}
                onChange={this.handleInputChange}
              />
            </div>
            <div>
              <label>Địa chỉ:</label>
              <input
                type="text"
                name="empAddress"
                value={employeeData.empAddress}
                onChange={this.handleInputChange}
              />
            </div>
            <div>
              <label>Lương trên giờ:</label>
              <input
                type="number"
                name="hourSalary"
                value={employeeData.hourSalary}
                onChange={this.handleInputChange}
              />
            </div>
            <div>
              <label>Trạng thái:</label>
              <select
                name="empStatus"
                value={employeeData.empStatus}
                onChange={this.handleInputChange}
              >
                <option value="">-- Chọn --</option>
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
                <option value="On Leave">On Leave</option>
                <option value="Suspended">Suspended</option>
              </select>
            </div>
            <div>
              <label>Giới tính:</label>
              <select
                name="empSex"
                value={employeeData.empSex}
                onChange={this.handleInputChange}
              >
                <option value="">-- Chọn --</option>
                <option value="Nam">Nam</option>
                <option value="Nữ">Nữ</option>
              </select>
            </div>
            <div>
              <label>Ngày sinh:</label>
              <input
                type="date"
                name="bdate"
                value={employeeData.bdate}
                onChange={this.handleInputChange}
              />
            </div>
            <div>
              <label>Tài khoản ngân hàng</label>
              <input
                type="text"
                name="empAccount"
                value={employeeData.empAccount}
                onChange={this.handleInputChange}
              />
            </div>
            <div>
              <label>ID cửa hàng:</label>
              <input
                type="text"
                name="empshopID"
                value={employeeData.empshopID}
                onChange={this.handleInputChange}
              />
            </div>
            <div>
              <label>ID quản lý:</label>
              <input
                type="text"
                name="empshopID"
                value={employeeData.supervisorID}
                onChange={this.handleInputChange}
              />
            </div>
            <div>
              <label>Emails:</label>
              <input
                type="text"
                name="empEmails"
                value={employeeData.empEmails}
                onChange={this.handleInputChange}
              />
            </div>
            <div>
              <label>Loại nhân viên:</label>
              <select
                name="empType"
                value={employeeData.empType}
                onChange={this.handleInputChange}
              >
                <option value="">-- Chọn --</option>
                <option value="Giao hàng">Giao hàng</option>
                <option value="Phục vụ">Phục vụ</option>
                <option value="Thu ngân">Thu ngân</option>
                <option value="Quản lý">Quản lý</option>
              </select>
            </div>
            {employeeData.empType === "Giao hàng" && (
              <div>
                <label>Giấy phép giao hàng:</label>
                <input
                  type="text"
                  name="delLicense"
                  value={employeeData.delLicense}
                  onChange={this.handleInputChange}
                />
              </div>
            )}
            {employeeData.empType === "Phục vụ" && (
              <div>
                <label>Vị trí phục vụ:</label>
                <input
                  type="text"
                  name="serPosition"
                  value={employeeData.serPosition}
                  onChange={this.handleInputChange}
                />
              </div>
            )}
            <div className="button-container">
              <button type="submit" className="btn btn-success">
                Cập nhật
              </button>
              <button type="button" className="btn btn-secondary" onClick={this.closeModal}>
                Đóng
              </button>
            </div>
            {updateError && <p className="error">{updateError}</p>}
            {successMessage && <p className="success">{successMessage}</p>}
          </form>
          
        </Modal>
      </tr>
    );
  }
}

export default OneRowData;
