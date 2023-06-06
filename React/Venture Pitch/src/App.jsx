import "./App.css";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import Landing from "./components/landingpage/Landing";
import Login from "./components/login-page/Login";
function App() {

  return (
    <>
      <div>
        <BrowserRouter>
          <Routes>
            <Route index element={<Landing />} />
            <Route path="/login" element={<Login />} />
          </Routes>
        </BrowserRouter>
      </div>
    </>
  );
}

export default App;
