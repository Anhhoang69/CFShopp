/* eslint-disable react/jsx-pascal-case */
import React, { Component } from "react";
import { Redirect } from "react-router-dom";
import styled from "styled-components";
import { FaUser } from "react-icons/fa";
import { RiLockPasswordFill } from "react-icons/ri";
import Iconn from "./icon.png";
import AppBackground from "./backgroud.png";

const Body = styled.div`
  background-image: url("../backgroud.png");
  width:100%;
  position: relative;
  overflow: hidden;
  height: 100vh;

`;
const Container = styled.div`
  width: 100%;
  display: flex;
  justify-content: center;
  height: 100vh;
`;
const _Input = styled.input`
  border: 0;
  border-bottom: 2px solid #8B4513;
  outline: 0;
  background: transparent;
  width: 60%;
`;
const _Button = styled.button`
  width: 260px;
  margin-left: 70px;
  height: 40px;
  background-color: #8B4513;
  color: black;
  font-weight: bold;
  border: none;
  border-radius: 10px;
  font-size: 1.8rem;
  transition: all 0.3s ease;
  opacity: 0.9;
  &:hover {
    opacity: 1;
    box-shadow: 0 1px 1px 1px rgba(0, 0, 0, 0.2),
      0 1px 2px 0 rgba(0, 0, 0, 0.19);
  }
`;

const Icon = styled.i`
  padding: 0px 5px 2px 0px;
  border-bottom: 2px solid white;
  margin-left: 18%;
  color: #8B4513;
`;
const Title = styled.p`
  text-align: center;
  font-family: Verdana, Geneva, Tahoma, sans-serif;
  font-weight: 600;
  font-size: 3rem;
  color: #8B4513;
  padding: 20px 0px 20px 0px;
`;

const Form = styled.form`
  width: 400px;
  height: 500px;
  margin-top: 140px;
  background-color: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(10px);
  border-radius: 70px;
`;
const Input_container = styled.div`
  padding: 0 0 10px 0;
`;
const Icon_logo = styled.img`
  width: 150px;
  height: 150px;
  margin-left: 120px;
  margin-top: 20px;
`;

const App_background = styled.img`
  width: 100%;
  height: 100%;
  position: absolute;
  z-index: -10;
`;

const Form_container = styled.div`
  position: absolute;
`;
class Login extends Component {
  constructor(props) {
    super(props);

    this.state = {
      email: "",
      password: "",
      isLogin: false,
    };
    this.handle = this.handle.bind(this);
    this.submit = this.submit.bind(this);
  }

  handle = (e) => {
    const name = e.target.name;
    const value = e.target.value;
    this.setState({
      [name]: value,
    });
  };

  submit = (event) => {
    event.preventDefault();
  
    // Hardcoded credentials
    const hardcodedEmail = "admin1@gmail.com";
    const hardcodedPassword = "123456";
  
    if (
      this.state.email === hardcodedEmail &&
      this.state.password === hardcodedPassword
    ) {
      // Simulate saving login info
      localStorage.setItem("accessToken", "dummyAccessToken");
      sessionStorage.setItem("role", "admin");
      sessionStorage.setItem("email", hardcodedEmail);
      this.setState({ isLogin: true });
      alert("Đăng nhập thành công");
    } else {
      alert("Sai tài khoản hoặc mật khẩu");
    }
  };
  
  render() {
    if (this.state.isLogin === true) {
      return <Redirect to='/list-employees' />;
    } else {
      return (
        <Body>
          <App_background src={AppBackground}/>
          <Container>
            <Form_container>
              <Form action='' method='post' onSubmit={this.submit}>
                <Icon_logo src={Iconn} />
                <Title>ĐĂNG NHẬP</Title>
                <Input_container>
                  <Icon>
                    <FaUser />
                  </Icon>
                  <_Input
                    type='email'
                    required
                    name='email'
                    placeholder='Email đăng nhập'
                    value={this.state.email}
                    onChange={this.handle}
                    autoFocus
                  />
                </Input_container>
                <br />
                <Input_container>
                  <Icon>
                    <RiLockPasswordFill />
                  </Icon>
                  <_Input
                    type='password'
                    name='password'
                    placeholder='Mật khẩu'
                    value={this.state.password}
                    onChange={this.handle}></_Input>
                </Input_container>
                <br />
                <_Button onClick={this.submit}>Đăng nhập</_Button>
                <br />
              </Form>
            </Form_container>
          </Container>
        </Body>
      );
    }
  }
}

export default Login;
