
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>>">
    <title>Title</title>
    <script type="text/javascript" src="static/js/jquery.js"></script>
    <%--引入样式--%>
    <link href="static/bootstrap-3.4.1-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        var curNum_;
        $(function () {
            to_page(1);

        });

        function to_page(pn) {
            $.ajax({
                url:"emp",
                data:"pn="+pn,
                type:"GET",
                dataType:"json",
                success:function (result) {
                    build_emp_table(result)
                    build_page_info(result)
                    build_page_nav(result)
                }
            });
        }




        // function build_emp_table(result) {
        //     $("#info").empty()
        //     var emp = result.extend.pageInfo.list;
        //     $.each(emp,function (index,item){
        //         $("#info").append("<tr>")
        //             .append("<th>"+item.empId+"</th>")
        //             .append("<th>"+item.empName+"</th>")
        //             .append("<th>"+item.empSex+"</th>")
        //             .append("<th>"+item.empEmail+"</th>")
        //             .append("<th>"+item.dept.deptName+"</th>")
        //             .append("<button type=\"button\" class=\"btn btn-success edit_btn\" aria-label=\"Left Align\">\n" +
        //                 "                                <span class=\"glyphicon glyphicon-pencil\">编辑</span>\n" +
        //                 "                            </button>&nbsp;&nbsp;")
        //             .append(" <button type=\"button\" class=\"btn btn-primary delete_btn\" aria-label=\"Left Align\">\n" +
        //                 "                                <span class=\"glyphicon glyphicon-trash\">删除</span>\n" +
        //                 "                            </button>")
        //             .append("</tr>")
        //     })
        // }
        function  build_emp_table(result) {
            //清空原表格数据
            $("#info").empty()
            //获取每个员工信息, 追加到表格中显示
            $.each(result.extend.pageInfo.list, function () {
                var empTr = $("<tr></tr>")
                var empCbTd = $('<td><input class="check_item" type="checkbox"></td>')
                var empIdTd = $("<td></td>").append(this.empId)
                var empNameTd = $("<td></td>").append(this.empName)
                var genderTd = $("<td></td>").append(this.empSex)
                var emailTd = $("<td></td>").append(this.empEmail)
                //避免部门为null
                var deptNameTd = $("<td></td>").append(this.dept.deptName)
                var editBtn = $("<button></button>").addClass("btn btn-info btn-sm edit_btn").append($("<span></span>")
                    .addClass("glyphicon glyphicon-edit")).append(" 编辑").attr("emp_id", this.empId)
                var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn").append($("<span></span>")
                    .addClass("glyphicon glyphicon-trash")).append(" 删除").attr("emp_id", this.empId)
                var operatorTd = $("<td></td>").append(editBtn).append(" ").append(delBtn)
                empTr.append(empCbTd).append(empIdTd).append(empNameTd).append(genderTd).append(emailTd).append(deptNameTd).append(operatorTd)
                    .appendTo("#info")
            })
        }

        function build_page_info(result) {
            $("#left_nav").empty()
            var curNum = result.extend.pageInfo.pageNum;
            var totalNum = result.extend.pageInfo.pages;
            var totalRecord = result.extend.pageInfo.total;
            $("#left_nav").append("当前第"+curNum+"页&nbsp;&nbsp;")
                .append("总共"+totalNum+"页&nbsp;&nbsp;")
                .append("一共"+totalRecord+"条记录")
            curNum_ = curNum;
        }

        function build_page_nav(result){
            //清空分页条信息
            $("#page_nav_area").empty();
            //Bootstrap中的写法，导航条中的信息都要写在ul变量中
            var ul = $("<ul></ul>").addClass("pagination");

            //首页
            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页"));

            //前一页
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));

            //如果当前遍历的页码是首页(没有前一页)，让首页和上一页不可点击
            if(result.extend.pageInfo.hasPreviousPage == false){
                //disabled是Bootstrap中的写法
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            } else{
                //为首页和前一页添加点击翻页的事件
                firstPageLi.click(function(){
                    to_page(1);
                });
                prePageLi.click(function(){
                    to_page(result.extend.pageInfo.pageNum-1);
                });
            }

            //后一页
            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));

            //末页
            var lastPageLi = $("<li></li>").append($("<a></a>").append("末页"));

            //如果当前遍历的页码是末页(没有下一页)，让末页和下一页不可点击
            if(result.extend.pageInfo.hasNextPage == false){
                nextPageLi.addClass("disabled");
                lastPageLi.addClass("disabled");
            }else{
                //为下一页和末页添加点击翻页的事件
                nextPageLi.click(function(){
                    to_page(result.extend.pageInfo.pageNum +1);
                });
                lastPageLi.click(function(){
                    to_page(result.extend.pageInfo.pages);
                });
            }

            //导航条中添加首页和前一页
            ul.append(firstPageLi).append(prePageLi);

            //遍历1，2，3之类的页码
            $.each(result.extend.pageInfo.navigatepageNums, function(index,item){

                //numLi / item表示遍历到的1，2，3之类的页码
                var numLi = $("<li></li>").append($("<a></a>").append(item));

                //如果当前遍历的页码就是当前的页码，让其高亮显示
                if(result.extend.pageInfo.pageNum == item){
                    //active是Bootstrap中的写法
                    numLi.addClass("active");
                }

                //单击事件，跳转到对应页面
                numLi.click(function(){
                    to_page(item);
                });

                //向导航条中添加1，2，3之类的页码
                ul.append(numLi);
            });

            //导航条中添加下一页和末页
            ul.append(nextPageLi).append(lastPageLi);

            //把ul导航条添加到导航条在页面中的位置
            var navEle = $("<nav></nav>").append(ul);
            navEle.appendTo("#page_nav_area");
        }



    </script>



    <script type="text/javascript">

        $(function () {
            $("#add_emp_btn").click(function () {
                resetForm("#add_emp_form")
                getDeptList("#add_emp_dept_select")
                $("#add_emp_modal").modal()
            });

            //这个bug找了我好久，动态框里的保存按钮的单击事件，一定要写在页面加载完成之后里面

            $("#add_emp_save_btn").click(function () {
                //用户非法绕过前端验证，此时就需要体现了后端验证的强大之处
                if(!validate_add_form()){
                    return false;
                }
                if($(this).attr("ajax-va")=="error"){
                    //在执行ajax请求之前，先判断，如果error，那么ajax请求不执行
                    return false;
                }
                $.ajax({
                    url:"add",
                    type:"POST",
                    data: $("#add_emp_form").serialize(),
                    success:function (result) {
                        if(result.code==100){
                            //员工保存成功
                            //1.关闭模态框
                            $('#add_emp_modal').modal('hide')
                            //来到最后一页，显示刚才保存的数据
                            to_page(9999);
                        }else {
                            console.log(result)
                        }

                    }
                })
            })

            $("#add_emp_name_input").change(function () {
                var empName = this.value;
                $.ajax({
                    url:"validate",
                    data:"empName="+empName,
                    type:"POST",
                    success:function (result) {
                        if(result.code==100){
                            show_validate_msg("#add_emp_name_input","success","此用户名可用");
                            //给保存按钮，添加一个属性，用来判断用户重复时，保存按钮是否能提交
                            $("#add_emp_save_btn").attr("ajax-va","success");
                        }
                        else {
                            show_validate_msg("#add_emp_name_input","error",result.extend.va_msg);
                            $("#add_emp_save_btn").attr("ajax-va","error","")
                        }
                    }
                })
            })

        })

        //前端校验表单数据
        function validate_add_form(){
            //1.拿到要校验的数据，使用正则表达式
            var empName = $("#add_emp_name_input").val()
            var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/
            if(!regName.test(empName)){
                //alert("用户名可以是2-5位中文或者6-16位英文和数组的组合");
                show_validate_msg("#add_emp_name_input","error","用户名可以是2-5位中文或者6-16位英文和数组的组合")
                return  false;
            }else {
               show_validate_msg("#add_emp_name_input","success","")
            }
            //2.验证邮箱信息
            var empEmail = $("#add_emp_email_input").val()
            var regEmail = /^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/
            if(!regEmail.test(empEmail)){
                //alert("邮箱格式不正确");
                show_validate_msg("#add_emp_email_input","error","邮箱格式不正确")
                return false;
            }else {
                show_validate_msg("#add_emp_email_input","success","")
            }
            return true;
        }



        function show_validate_msg(ele,status,msg) {
            $(ele).parent().removeClass("has-success has-error")
            $(ele).next("span").text("")
            if("success"==status) {
                $(ele).parent().addClass("has-success");
                $(ele).next("span").text(msg)
            }
            else if("error"==status){
                    $(ele).parent().addClass("has-error");
                    $(ele).next("span").text(msg);
                }
        }


        function resetForm(selector) { //表单选择器
            //重置表单内容
            $(selector)[0].reset()
            //重置表单样式
            $(selector).find("*").removeClass("has-error has-success")
            $(selector).find(".glyphicon").removeClass("glyphicon-remove glyphicon-ok")
            $(selector).find(".help-block").text("")
        }

        function getDeptList(ele) {
            $(ele).empty()
            $.ajax({
                url:"dept",
                type:"GET",
                success:function (result) {
                   //console.log(result)
                    //显示部门信息在下拉列表中
                    $("#add_emp_dept_select").empty()
                    $.each(result.extend.dept,function (i,n) {
                        //<option value="1">起飞部</option>  attr是给option这个标签添加属性
                        var optionEle = $("<option></option>").append(n.deptName).attr("value",n.deptId)
                        optionEle.appendTo(ele)
                    })
                }
            })
        }
    </script>

    <script type="text/javascript">
        $(function () {
            $(document).on("click",".edit_btn",function () {
                getDeptList("#modify_emp_modal select")
                getEmp($(this).attr("emp_id"))
                //把员工的id传递给模态框的更新按钮
                $("#modify_emp_save_btn").attr("emp_id",$(this).attr("emp_id"))
                $("#modify_emp_modal").modal({
                    backdrop:"static"
                })
            })

            $(document).on("click",".delete_btn",function () {
                var empId = $(this).attr("emp_id")
                var empName = $(this).parents("tr").find("td:eq(2)").text()


                if (confirm("你确定要删除【" + empName + "】吗?")) {
                    //Ajax发送员工删除请求
                    $.ajax({
                        type: "POST",
                        url: "delete/" + empId,
                        data: "_method=DELETE",
                        dataType: "json",
                        success: function (result) {
                           to_page(curNum_)
                        }
                    })
                }
            })


            $("#modify_emp_save_btn").click(function () {
                var empEmail = $("#modify_emp_email_input").val()
                var regEmail = /^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/
                if(!regEmail.test(empEmail)){
                    //alert("邮箱格式不正确");
                    show_validate_msg("#modify_emp_email_input","error","邮箱格式不正确")
                    return false;
                }else {
                    show_validate_msg("#modify_emp_email_input","success","")
                }

                $.ajax({
                    url:"update/"+$(this).attr("emp_id"),
                    type:"POST",
                    //这边就是将post请求，转为put请求
                    //<!--使用REST风格的URI,将普通的post请求转为指定的delete或者put请求-->
                    data:$("#modify_emp_modal form").serialize()+"&_method=PUT",
                    success:function (result) {
                        $("#modify_emp_modal").modal("hide");
                        to_page(curNum_)

                    }
                })
            })
            //实现全选/全不选
            $("#check_all").click(function () {
                var flag = $(this).prop("checked") //这里必须用prop(), attr()只能获取显式指定的属性值
                $(".check_item").prop("checked", flag)
            })

            $(document).on("click", ".check_item", function () {
                //获取当前的选中个数
                var checkCount = $(".check_item:checked").length
                //如果选中个数和复选框总个数相等, 就把全选框勾上, 否则划掉
                var flag = checkCount == $(".check_item").length;
                if (flag) {
                    $("#check_all").prop("checked", true)
                } else {
                    $("#check_all").prop("checked", false)
                }
            })

            $("#delete_emp_all_btn").click(function () {
                //如果没有一个选中的, 则直接返回
                if ($(".check_item:checked").length == 0) {
                    alert("请勾选要删除的条目!")
                    return false
                }
                var empNames = "";
                var ids = ""
                $.each($(".check_item:checked"), function () {
                    empNames += $(this).parents("tr").find("td:eq(2)").text() + ", " //拼接要删除的员工姓名
                    ids += $(this).parents("tr").find("td:eq(1)").text() + "-" //拼接要删除的员工id
                })
                empNames = empNames.substring(0, empNames.length - 2) //去掉最后一个", "
                ids = ids.substring(0, ids.length - 1) //去掉最后一个"-"
                //弹出确认框
                if (confirm("你确定要删除【" + empNames + "】吗？")) {
                    //发送Ajax批量删除请求
                    $.ajax({
                        type: "POST",
                        url: "delete/" + ids,
                        data: "_method=DELETE",
                        dataType: "json",
                        success: function (result) {
                            alert(result.msg);
                            to_page(curNum_)
                        }
                    })
                }
            })

        })

        function getEmp(id) {
            $.ajax({
                url:"emp/"+id,
                type:"GET",
                success:function (result) {
                   var empData = result.extend.emp;
                   $("#empName").text(empData.empName);
                   $("#modify_emp_email_input").val(empData.empEmail);
                   $("#modify_emp_modal input[name=empSex]").val(empData.empSex);
                   $("#modify_emp_modal select").val([empData.cid]);
                }
            })
        }



    </script>

</head>
<body>

<%--修改员工的模态框--%>
<div id="modify_emp_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="addEmpModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">修改员工</h4>
            </div>
            <%-- 表单部分 --%>
            <div class="modal-body">
                <form id="modify_emp_form" action="#" method="post" class="form-horizontal">
                    <div class="form-group">
                        <label for="add_emp_name_input" class="col-sm-2 control-label">姓名</label>
                        <div class="col-sm-10 has-feedback">
                            <p id ="empName" class="form-control-static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="add_emp_email_input" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10 has-feedback">
                            <input type="email" class="form-control has-feedback" id="modify_emp_email_input"
                                   placeholder="Past lives@foxmail.com"
                                   name="empEmail">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="add_emp_gender_input1" class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input checked type="radio" name="empSex" id="modify_emp_gender_input1" value="男"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="empSex" id="modify_emp_gender_input2" value="女"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="add_emp_dept_select" class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-4">
                            <select id="modify_emp_dept_select" name="cid" class="form-control">
                                <%-- 从数据库中查询部门信息 --%>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <%-- 保存和关闭按钮 --%>
            <div class="modal-footer">
                <button id="modify_emp_close_btn" type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="modify_emp_save_btn" type="button" class="btn btn-primary">保存</button>
                <%-- 默认禁用 --%>
            </div>
        </div>
    </div>
</div>


<!--添加员工的模态框-->
<div id="add_emp_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="addEmpModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">新增员工</h4>
            </div>
            <%-- 表单部分 --%>
            <div class="modal-body">
                <form id="add_emp_form" action="#" method="post" class="form-horizontal">
                    <div class="form-group">
                        <label for="add_emp_name_input" class="col-sm-2 control-label">姓名</label>
                        <div class="col-sm-10 has-feedback">
                            <input type="text" class="form-control" id="add_emp_name_input" placeholder="Past lives"
                                   name="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="add_emp_email_input" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10 has-feedback">
                            <input type="email" class="form-control has-feedback" id="add_emp_email_input"
                                   placeholder="Past lives@foxmail.com"
                                   name="empEmail">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="add_emp_gender_input1" class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input checked type="radio" name="empSex" id="add_emp_gender_input1" value="男"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="empSex" id="add_emp_gender_input2" value="女"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="add_emp_dept_select" class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-4">
                            <select id="add_emp_dept_select" name="cid" class="form-control">
                                <%-- 从数据库中查询部门信息 --%>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <%-- 保存和关闭按钮 --%>
            <div class="modal-footer">
                <button id="add_emp_close_btn" type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="add_emp_save_btn" type="button" class="btn btn-primary">保存</button>
                <%-- 默认禁用 --%>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <!--标题-->
    <div class="row">
        <div class="col-lg-12">
            <h1>SSM-CURD</h1>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 col-md-offset-10">
            <button id="add_emp_btn" type="button"  class="btn btn-success" >
                新增
            </button>
            <button id="delete_emp_all_btn" type="button" class="btn btn-primary">
                删除
            </button>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <table class="table">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id = "check_all">
                    </th>
                    <th>#</th>
                    <th>empName</th>
                    <th>empSex</th>
                    <th>empEmail</th>
                    <th>empDept</th>
                    <th>Operation</th>
                </tr>
                </thead>
                <tbody id="info">
                </tbody>
            </table>
        </div>
    </div>
    <!--显示分页信息-->
    <div class="row">
        <div id="left_nav" class=" col-md-6">
        </div>
        <div id="page_nav_area" class=" col-md-6">
        </div>
    </div>
</div>
</body>
</html>
