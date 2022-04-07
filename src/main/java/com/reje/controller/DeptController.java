package com.reje.controller;

import com.reje.pojo.Dept;
import com.reje.pojo.Msg;
import com.reje.service.DeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DeptController {

    @Autowired
     private DeptService deptService;

    @ResponseBody
    @RequestMapping("/dept")
    public Msg returnWithDeptList(){

        List<Dept> deptList = deptService.DeptList();
        //类中的静态方法直接调用
        return Msg.success().add("dept",deptList);
    }
}
