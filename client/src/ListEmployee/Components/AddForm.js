import React, { Component } from "react";
import { Link } from "react-router-dom";

class AddForm extends Component {
  constructor(props) {
    super(props);
    this.state = {
      empID: "",
      empStartDate: "",
      empName: "",
      empPhoneNumber: "",
      empSsn: "",
      bdate: "",
      empAccount: "",
      empType: "",
      empSex: "",
      empAddress: "",
      hourSalary: "",
      empStatus: "",
      supervisorID: "",
      empshopID: "",
      empEmail: "",
      errors: {},
    };
  }

  validateForm = () => {
    const {
      empID,
      empPhoneNumber,
      empSsn,
      bdate,
      hourSalary,
      empSex,
      empStatus,
      empEmail,
    } = this.state;
    let errors = {};

    // Kiểm tra mã nhân viên
    if (empID.length !== 8) errors.empID = "ID nhân viên phải có 8 ký tự.";

    // Kiểm tra số điện thoại
    if (empPhoneNumber.length !== 10 || !/^\d+$/.test(empPhoneNumber)) {
      errors.empPhoneNumber = "Số điện thoại phải có 10 chữ số.";
    }

    // Kiểm tra số CCCD
    if (empSsn.length !== 12 || !/^\d+$/.test(empSsn)) {
      errors.empSsn = "Số CCCD phải có 12 chữ số.";
    }

    // Kiểm tra ngày sinh
    const today = new Date();
    const birthDate = new Date(bdate);
    const age = today.getFullYear() - birthDate.getFullYear();
    if (birthDate > today) errors.bdate = "Ngày sinh không hợp lệ.";
    if (age < 18) errors.bdate = "Nhân viên phải từ 18 tuổi trở lên.";

    // Kiểm tra lương theo giờ
    if (hourSalary <= 0) errors.hourSalary = "Lương theo giờ phải lớn hơn 0.";

    // Kiểm tra giới tính
    if (!["M", "F"].includes(empSex)) {
      errors.empSex = "Giới tính không hợp lệ. Phải là M hoặc F.";
    }

    // Kiểm tra trạng thái nhân viên
    if (!["Active", "Inactive", "On Leave", "Suspended"].includes(empStatus)) {
      errors.empStatus =
        "Trạng thái không hợp lệ. Phải là Active, Inactive, On Leave hoặc Suspended.";
    }

    // Kiểm tra email
    const emailRegex =
      /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(empEmail)) {
      errors.empEmail = "Địa chỉ email không hợp lệ.";
    }

    this.setState({ errors });
    return Object.keys(errors).length === 0;
  };

  onChange = (event) => {
    const { name, value } = event.target;
    this.setState({
      [name]: value,
    });
  };

  onSubmit = (event) => {
    event.preventDefault();
    if (this.validateForm()) {
      // Tạm thời demo gửi console.log thay vì gọi API
      console.log("Form submitted successfully", this.state);
      alert("Form đã được gửi thành công!");
      // Reset form
      this.setState({
        empID: "",
        empStartDate: "",
        empName: "",
        empPhoneNumber: "",
        empSsn: "",
        bdate: "",
        empAccount: "",
        empType: "",
        empSex: "",
        empAddress: "",
        hourSalary: "",
        empStatus: "",
        supervisorID: "",
        empshopID: "",
        empEmail: "",
        errors: {},
      });
    }
  };

  render() {
    const { errors } = this.state;
    return (
      <div className="addForm">
        <div className="back">
          <Link to="/list-employees" className="btn btn-danger">
            <span className="fa fa-arrow-left"></span> &nbsp; Quay lại
          </Link>
        </div>
        <div className="col-xs-5 col-sm-5 col-md-5 col-lg-5 center">
          <div className="panel panel-warning">
            <div className="panel-heading">
              <h3 className="panel-title">Thêm nhân viên</h3>
            </div>
            <div className="panel-body">
              <form onSubmit={this.onSubmit}>
                <div className="form-group">
                  <label>ID nhân viên:</label>
                  <input
                    type="text"
                    className="form-control"
                    name="empID"
                    value={this.state.empID}
                    onChange={this.onChange}
                  />
                  {errors.empID && <p className="text-danger">{errors.empID}</p>}
                  <label>Họ và tên:</label>
                  <input
                    type="text"
                    className="form-control"
                    name="empName"
                    value={this.state.empName}
                    onChange={this.onChange}
                  />
                  <label>Giới tính:</label>
                  <select
                    className="form-control"
                    name="empSex"
                    value={this.state.empSex}
                    onChange={this.onChange}
                  >
                    <option value="">--Chọn--</option>
                    <option value="M">Nam</option>
                    <option value="F">Nữ</option>
                  </select>
                  {errors.empSex && (
                    <p className="text-danger">{errors.empSex}</p>
                  )}
                  <label>Ngày sinh:</label>
                  <input
                    type="date"
                    className="form-control"
                    name="bdate"
                    value={this.state.bdate}
                    onChange={this.onChange}
                  />
                   {errors.bdate && <p className="text-danger">{errors.bdate}</p>}
                   <label>Số CCCD:</label>
                  <input
                    type="text"
                    className="form-control"
                    name="empSsn"
                    value={this.state.empSsn}
                    onChange={this.onChange}
                  />
                  {errors.empSsn && (
                    <p className="text-danger">{errors.empSsn}</p>
                  )}
                  <label>Số điện thoại:</label>
                  <input
                    type="text"
                    className="form-control"
                    name="empPhoneNumber"
                    value={this.state.empPhoneNumber}
                    onChange={this.onChange}
                  />
                  {errors.empPhoneNumber && (
                    <p className="text-danger">{errors.empPhoneNumber}</p>
                  )}
                   <label>Email:</label>
                  <input
                    type="email"
                    className="form-control"
                    name="empEmail"
                    value={this.state.empEmail}
                    onChange={this.onChange}
                  />
                  {errors.empEmail && (
                    <p className="text-danger">{errors.empEmail}</p>
                  )}
                   <label>Địa chỉ:</label>
                  <input
                    type="text"
                    className="form-control"
                    name="empAddress"
                    value={this.state.empAddress}
                    onChange={this.onChange}
                  />
                  <label>Ngày bắt đầu:</label>
                  <input
                    type="date"
                    className="form-control"
                    name="empStartDate"
                    value={this.state.empStartDate}
                    onChange={this.onChange}
                  />
                  <label>Loại nhân viên:</label>
                  <input
                    className="form-control"
                    name="empType"
                    required
                    value={this.state.empType}
                    onChange={this.onChange}
                  >
                  </input>
                  
                  <label>Tài khoản ngân hàng:</label>
                  <input
                    type="text"
                    className="form-control"
                    required
                    name="empAccount"
                    value={this.state.empAccount}
                    onChange={this.onChange}
                  />
                  
                  <label>Lương theo giờ:</label>
                  <input
                    type="number"
                    className="form-control"
                    name="hourSalary"
                    value={this.state.hourSalary}
                    onChange={this.onChange}
                  />
                  {errors.hourSalary && (
                    <p className="text-danger">{errors.hourSalary}</p>
                  )}
                 
                 <label>Trạng thái:</label>
                  <select
                    className="form-control"
                    name="empStatus"
                    value={this.state.empStatus}
                    onChange={this.onChange}
                  >
                    <option value="">--Chọn--</option>
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                    <option value="On Leave">On Leave</option>
                    <option value="Suspended">Suspended</option>
                  </select>
                  <label>ID người giám sát:</label>
                  <input
                    type="text"
                    className="form-control"
                    name="supervisorID"
                    value={this.state.supervisorID}
                    onChange={this.onChange}
                  />
                  <label>ID cửa hàng:</label>
                  <input
                    type="text"
                    className="form-control"
                    required
                    name="empshopID"
                    value={this.state.empshopID}
                    onChange={this.onChange}
                  />
                 

                  <br />
                  <div className="text-center">
                    <button
                      type="submit"
                      className="btn btn-primary"
                    >
                      Thêm nhân viên
                    </button>{" "}
                    &nbsp;
                    <Link to="/list-employees" className="btn btn-danger">
                      Hủy
                    </Link>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default AddForm;
