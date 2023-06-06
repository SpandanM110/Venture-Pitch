import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter, Route, Switch, Redirect } from "react-router-dom";

import "@fortawesome/fontawesome-free/css/all.min.css";

import Landing from "./components/Landing-page/src/views/Landing";
import Dashboard from "./components/Dashboard-page/src/views/Dashboard";
import Login from "./components/Login-page/src/views/Login";

ReactDOM.render(
  <BrowserRouter>
    <Switch>
      <Route exact path='/'>
        <Redirect to='/landing' />
      </Route>
      <Route path='/landing' component={Landing} />
      <Route path='/dashboard' component={Dashboard} />
      <Route path='/login' component={Login} />
      <Redirect to='/login' />
    </Switch>
  </BrowserRouter>,
  document.getElementById("root")
);