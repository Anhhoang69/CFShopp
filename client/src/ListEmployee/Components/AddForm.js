import React, { Component } from "react";
import { Link } from "react-router-dom";
import axios from "axios";

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
      empEmails: "", // Nhiều email, cách nhau bằng dấu phẩy
      delLicense: "",
      serPosition: "",
      errors: {},
      successMessage: "",
    };
  }

  validateForm = () => {
    const {
      empID,
      empshopID,
      supervisorID,
      empPhoneNumber,
      empSsn,
      bdate,
      hourSalary,
      empSex,
      empStatus,
      empEmails,
      empType,
      delLicense,
      serPosition,
    } = this.state;
    let errors = {};

    // Kiểm tra mã nhân viên
    if (empID.length !== 8) errors.empID = "ID nhân viên phải có 8 ký tự.";

    if (empshopID.length !== 5) errors.empshopID = "ID cửa hàng phải có 5 ký tự.";
    if (supervisorID.length !== 8) errors.supervisorID = "ID quản lý phải có 8 ký tự.";


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
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const emailList = empEmails.split(",");
    emailList.forEach((email) => {
      if (!emailRegex.test(email.trim())) {
        errors.empEmails = "Địa chỉ email không hợp lệ.";
      }
    });
    // Kiểm tra điều kiện bổ sung cho từng loại nhân viên
    if (empType === "Giao hàng" && !delLicense) {
      errors.delLicense = "Giấy phép giao hàng là bắt buộc cho nhân viên giao hàng.";
    }
    if (empType === "Phục vụ" && !serPosition) {
      errors.serPosition = "Vị trí phục vụ là bắt buộc cho nhân viên phục vụ.";
    }

    this.setState({ errors });
    return Object.keys(errors).length === 0;
  };

  onChange = (event) => {
    const { name, value } = event.target;
    this.setState({
      [name]: value,  // Cập nhật tất cả các giá trị trong state
      successMessage: "",
    });
  };
  

  onSubmit = async (event) => {
    event.preventDefault();
    if (this.validateForm()) {
      const {
        empID,
        empStartDate,
        empName,
        empPhoneNumber,
        empSsn,
        bdate,
        empAccount,
        empType,
        empSex,
        empAddress,
        hourSalary,
        empStatus,
        supervisorID,
        empshopID,
        empEmails,
        delLicense,
        serPosition,
      } = this.state;

      try {
        const response = await axios.post("http://localhost:5000/add-employee", {
          empID,
          empStartDate,
          empName,
          empPhoneNumber,
          empSsn,
          bdate,
          empAccount,
          empType,
          empSex,
          empAddress,
          hourSalary,
          empStatus,
          supervisorID,
          empshopID,
          empEmails,
          delLicense: empType === "Giao hàng" ? delLicense : null,
          serPosition: empType === "Phục vụ" ? serPosition : null,
        });

        this.setState({
          successMessage: response.data.message,
          errors: {},
        });
      } catch (error) {
        const errorMsg =
          error.response?.data?.error || "Có lỗi xảy ra khi thêm nhân viên.";
        this.setState({ errors: { form: errorMsg } });
      }
    }
  };
  render() {
    const { errors, successMessage } = this.state;
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
                  <label>Email (Nhiều email cách nhau bằng dấu phẩy):</label>
                  <input
                    type="text"
                    className="form-control"
                    name="empEmails"
                    value={this.state.empEmails}
                    onChange={this.onChange}
                  />
                  {errors.empEmails && (
                    <p className="text-danger">{errors.empEmails}</p>
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
                  
                  <label>Tài khoản ngân hàng:</label>
                  <input
                    type="text"
                    className="form-control"
                    required
                    name="empAccount"
                    value={this.state.empAccount}
                    onChange={this.onChange}
                  />
                  <label>Loại nhân viên:</label>
                  <select
                    className="form-control"
                    name="empType"
                    value={this.state.empType} // Đảm bảo dùng this.state.empType
                    onChange={this.onChange}
                  >
                    <option value="">--Chọn--</option>
                    <option value="Giao hàng">Giao hàng</option>
                    <option value="Phục vụ">Phục vụ</option>
                    <option value="Thu ngân">Thu ngân</option>
                    <option value="Quản lý">Quản lý</option>
                  </select>
                  {this.state.empType === "Giao hàng" && (
                    <>
                      <label>Giấy phép giao hàng:</label>
                      <input
                        type="text"
                        className="form-control"
                        name="delLicense"
                        value={this.state.delLicense}
                        onChange={this.onChange}
                      />
                      {errors.delLicense && (
                        <p className="text-danger">{errors.delLicense}</p>
                      )}
                    </>
                  )}

                  {/* Trường nhập vị trí phục vụ (chỉ hiện khi empType là "Phục vụ") */}
                  {this.state.empType === "Phục vụ" && (
                    <>
                      <label>Vị trí phục vụ:</label>
                      <input
                        type="text"
                        className="form-control"
                        name="serPosition"
                        value={this.state.serPosition}
                        onChange={this.onChange}
                      />
                      {errors.serPosition && (
                        <p className="text-danger">{errors.serPosition}</p>
                      )}
                    </>
                  )}
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
                  {errors.empStatus && (
                    <p className="text-danger">{errors.empStatus}</p>
                  )}
                  <label>ID người giám sát:</label>
                  <input
                    type="text"
                    className="form-control"
                    name="supervisorID"
                    value={this.state.supervisorID}
                    onChange={this.onChange}
                  />
                   {errors.supervisorID && <p className="text-danger">{errors.supervisorID}</p>}
                  <label>ID cửa hàng:</label>
                  <input
                    type="text"
                    className="form-control"
                    required
                    name="empshopID"
                    value={this.state.empshopID}
                    onChange={this.onChange}
                  />
                   {errors.empshopID && <p className="text-danger">{errors.empshopID}</p>}
                  {/* Thông báo lỗi hoặc thành công */}
                  {errors.form && (
                    <p className="text-danger text-center">{errors.form}</p>
                  )}
                  {successMessage && (
                    <p className="text-success text-center">{successMessage}</p>
                  )}
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
