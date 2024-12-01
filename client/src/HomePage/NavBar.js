import React, { Component } from "react";
import "./NavBar.css";
import "boxicons";
import { BsClipboardData } from "react-icons/bs";
import { BiLogOut } from "react-icons/bi";
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";
import routes from "../router";
import { Redirect } from "react-router";

class NavBar extends Component {
  constructor(props) {
    super(props);
    this.state = {
      role: "",
      chooseListEmployee: true,
    };
  }

  componentDidMount() {
    this.setState({
      role: sessionStorage.getItem("role"),
    });
  }

  open = () => {
    this.setState({
      openNav: !this.state.openNav,
    });
  };

  chooseListEmployee = () => {
    this.setState({
      chooseLogout: false,
    });
  };
  chooseLogout = () => {
    localStorage.removeItem("accessToken");
    sessionStorage.removeItem("role");
    sessionStorage.removeItem("email");
    alert("Bạn đã đăng xuất!");
    this.setState({ role: null }); 
  };

  render() {
    if (localStorage.getItem("accessToken") == null) {
      return <Redirect to='/login' />;
    }
    var {
      role,
      openNav,
      chooseListEmployee,
    } = this.state;
    console.log(role);
   
    if (role === "admin"){
      return (
        <Router>
        <section className='body'>
          <div className={openNav ? "sidebar open" : "sidebar"}>
            <div className='logo-details'>
             
              <div className='logo_name'>MENU</div>
              <div id='btn' onClick={this.open}>
                <box-icon name='menu' color='#ffffff'></box-icon>
              </div>
            </div>
            <ul className='nav-list'>
              <li
                id='liststu'
                className={
                  chooseListEmployee ? "home" : ""
                }
                onClick={this.chooseListEmployee}>
                <Link to='/list-employees'>
                
                  <ul>
                  <div className='icon'>
                    <BsClipboardData />
                  </div>
                  <span className='links_name'>DS Nhân viên</span>
                  </ul>
                </Link>
                <span className='tooltip'>DS Nhân viên</span>
              </li>   
              <li className='logout' onClick={this.chooseLogout}>
                <a href='/'>
                  
                  <ul>
                  <div className='icon'>
                    <BiLogOut />
                  </div>
                  <span className='links_name'>Đăng Xuất</span>
                  </ul>
                </a>
                <span className='tooltip'>Đăng Xuất</span>
              </li>
            </ul>
          </div>
          <div className={openNav ? "nav_open" : "nav_close"}>
            <div>{this.show(routes)}</div>
          </div>
        </section>
      </Router>
      );
    } else {
      return (
        <div>BTL!</div>
      );
    }
  }
  show = (routes) => {
    var result = null;
    if (routes.length > 0) {
      result = routes.map((route, index) => {
        return (
          <Route
            key={index}
            path={route.path}
            exact={route.exact}
            component={route.main}
          />
        );
      });
    }
    return <Switch>{result}</Switch>;
  };
}

export default NavBar;
