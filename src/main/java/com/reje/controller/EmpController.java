package com.reje.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.reje.pojo.Emp;
import com.reje.pojo.Msg;
import com.reje.service.EmpService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmpController {

    @Autowired
    EmpService empService;

//    @RequestMapping("/emp")
//    public String returnEmpList(@RequestParam(value = "pn",defaultValue = "1")Integer pn,
//                                Model model){
//        //response.setCharacterEncoding("UTF-8");
//        PageHelper.startPage(pn,5);
//        List<Emp> empList = empService.EmpList();
//        PageInfo<Emp> pageInfo = new PageInfo<>(empList,5);
//        System.out.println(pageInfo);
//        model.addAttribute(pageInfo);
//        return "list";
    @RequestMapping("/emp")
    @ResponseBody
    public Msg getEmpWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn){
        PageHelper.startPage(pn,5);
        List<Emp> emp = empService.EmpList();
        PageInfo<Emp> pageInfo = new PageInfo(emp,5);
        //类的静态方法，可以不实例化，直接调用
        return Msg.success().add("pageInfo",pageInfo);
    }

    @RequestMapping(value = "/add",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Emp emp, BindingResult result){
        if(result.hasErrors()){
            //校验失败，应该返回失败，在模态框中显示失败的错误信息
            Map<String,Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error : errors) {
                map.put(error.getField(),error.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        }else {
            empService.insert(emp);
            return  Msg.success();
        }
    }


    @RequestMapping(value = "/validate",method = RequestMethod.POST)
    @ResponseBody
    public Msg validateUserName(@RequestParam(value = "empName") String name){
        String regxName ="(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5}$)";
        if (!name.matches(regxName)) {
            return Msg.fail().add("va_msg","用户名必须是2-5位中文或者6-16位英文和数组的组合");
        }

        int i = empService.selectByName(name);
        if(i==0){
            return Msg.success();
        }
        else {
            return Msg.fail().add("va_msg","用户名不可用");
        }
    }

    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    //使用Restful的方式发送请求
    //@PathVariable:接收请求路径中占位符的值   @RequestMapping中的 value 的{id}名 必须和 @PathVariable 的value的名 保持一致
    public Msg getEmp(@PathVariable(value = "id")Integer empId){
        Emp emp = empService.getEmp(empId);
        return Msg.success().add("emp",emp);
    }

    /**
     *AJAX PUT请求
     * 问题：
     * 请求体中有数据
     * 但是Emp对象封装不上
     *
     * 原因：
     * Tomcat：1.将请求体中的数据，封装一个map
     *         2.request.getParameter("empName")就会从这个map中取值
     *         3.SpringMVC封装pojo对象的时候
     *              会把POJO中每个属性的值，request.getParameter("empName")
     *
     *AJAX发送PUT请求引发的血案
     *  Tomcat一看是put就不会封装数据为map，只有POST形式的请求才封装请求体为map
     *
     *
     */

    @RequestMapping(value = "/update/{empId}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateEmp(Emp emp){
        empService.updateEmp(emp);
        return Msg.success();
    }

    @RequestMapping(value = "/delete/{ids}",method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteEmp(@PathVariable(value = "ids") String ids){
        List<Integer> list=  new ArrayList<>();
        if(ids.contains("-")){
            String[] str_ids = ids.split("-");
            for (String str_id : str_ids) {
                Integer id = Integer.parseInt(str_id);
                list.add(id);
            }
           empService.deleteBatch(list);
        }
        else {
            Integer empId = Integer.parseInt(ids);
            empService.deleteEmp(empId);
        }

        return Msg.success();

    }
}
