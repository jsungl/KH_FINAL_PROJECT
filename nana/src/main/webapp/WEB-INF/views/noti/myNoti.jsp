<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>
<!-- <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script> -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/timeline.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/button.css" />
<!-- <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script> -->
<!------ Include the above in your HEAD tag ---------->
<style>
.notiContent {
	color: black;
}
.notiContent:hover {
	color: black;
}

.alarmLi {
	box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
}
</style>
<div class="container mt-5 mb-5">
	<div class="row">
		<div class="col-md-6 offset-md-3">
			<h4 class="text-center">내소식</h4>
			<c:if test="${not empty notiList}">
			<ul class="timeline">
				<c:forEach var="noti" items="${notiList}" varStatus="status">
				<li class="alarmLi border ml-3">
					<div class="p-3">
						<span style="color: #f0ad4e">좋아요 알림</span>
						<span class="pull-right sendTime"><fmt:formatDate value="${noti.sendTime}" pattern="yyyy/MM/dd HH:mm:ss"/>
						<span><a href="#" id="deleteAlarm" data-no="${noti.notiNo}" onclick="deleteAlarm(this);"><i class="fa fa-trash" aria-hidden="true"></i>&nbsp;</a></span>
						</span>
						<hr />
						<a href="${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${noti.boardNo}" class="notiContent"><p>${noti.messageContent}</p></a>
					</div>
				</li>
				<form:form name="alarmDelFrm" action="${pageContext.request.contextPath}/noti/deleteNoti.do" method="post">
					<input type="hidden" name="notiNo" value="" />
				</form:form>
				</c:forEach>
			</ul>
			</c:if>
			
			<c:if test="${empty notiList}">
				<p>알림이 존재하지 않습니다.</p>
			</c:if>
		</div>
	</div>
</div>
<script>
/* $("#deleteAlarm").click(e => {
	var notiNo = $(elem).data("no");
	console.log(notiNo);
	$("[name=alarmDelFrm]").fine("[name=notiNo]").val(notiNo);
	$("[name=alarmDelFrm]").submit();
}); */

function deleteAlarm(elem) {
	var notiNo = $(elem).data("no");
	console.log(notiNo);
	$("[name=alarmDelFrm]").find("[name=notiNo]").val(notiNo);
	$("[name=alarmDelFrm]").submit();
}
</script>
<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>