
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<html>
<head>
    <title>员工列表</title>
    <base href="<%=basePath%>>">
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <%--引入样式--%>
    <link href="static/bootstrap-3.4.1-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>
</head>
<body>
    <div class="container">
        <!--标题-->
        <div class="row">
            <div class="col-lg-12">
                <h1>SSM-CURD</h1>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4 col-md-offset-10">
                <button type="button" class="btn btn-success">
                    <span class="glyphicon glyphicon-pencil">
                        新增
                    </span>

                </button>
                <button type="button" class="btn btn-primary">
                     <span class="glyphicon glyphicon-trash">
                        删除
                     </span>
                </button>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <table class="table">
                    <tr>
                        <th>#</th>
                        <th>empName</th>
                        <th>empSex</th>
                        <th>empEmail</th>
                        <th>empDept</th>
                        <th>Operation</th>
                    </tr>
                <c:forEach items="${pageInfo.list}" var="emp">
                    <tr>
                        <th>${emp.empId}</th>
                        <th>${emp.empName}</th>
                        <!--三目运算-->
                        <th>${emp.empSex}</th>
                        <th>${emp.empEmail}</th>
                        <th>${emp.dept.deptName}</th>
                        <th>
                            <button type="button" class="btn btn-success" aria-label="Left Align">
                                <span class="glyphicon glyphicon-pencil">编辑</span>
                            </button>

                            <button type="button" class="btn btn-primary" aria-label="Left Align">
                                <span class="glyphicon glyphicon-trash">删除</span>
                            </button>
                        </th>
                    </tr>

                </c:forEach>
                </table>
            </div>
        </div>
        <!--显示分页信息-->
        <div class="row">
           <div class=" col-md-6">
               当前第${pageInfo.pageNum}页，总共${pageInfo.pages},一共${pageInfo.total}条记录
           </div>
            <div class=" col-md-6">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li><a href="emp?pn=${pageInfo.pageNum=1}">首页</a></li>
                        <c:if test="${pageInfo.hasPreviousPage}">
                            <li>
                                <a href="emp?pn=${pageInfo.pageNum-1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach items="${pageInfo.navigatepageNums}" var="pageNum">
                            <c:if test="${pageNum==pageInfo.pageNum}">
                                <li class="active"><a href="emp?pn=${pageNum}">${pageNum}</a></li>
                            </c:if>
                            <c:if test="${pageNum!=pageInfo.pageNum}">
                                <li><a href="emp?pn=${pageNum}">${pageNum}</a></li>
                            </c:if>
                        </c:forEach>
                        <c:if test="${pageInfo.hasNextPage}">
                            <li>
                                <a href="emp?pn=${pageInfo.pageNum+1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <li><a href="emp?pn=${pageInfo.pages}">末页</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

</body>
</html>
