<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/button.css" />
<style>
/* .table td, .table th {
	border-top: 1px solid black;
}

.table-striped tbody tr:nth-of-type(odd){
	background-color : rgba(253, 238, 179,.3);
}
.table-striped tbody tr{
	background-color : #FFEDB8;
}

.table-hover > tbody > tr:hover {
  background-color: rgba(253, 238, 179,.3);
} */
tr {
	cursor: pointer;
}
</style>
<div class="container">
	<ul class="nav nav-pills" id="admin-pills">
		<li class="nav-item"><a class="nav-link"
			href="${pageContext.request.contextPath}/admin/adminManagement.do">관리자
				홈</a></li>
		<li class="nav-item"><a class="nav-link active" id="active"
			href="${pageContext.request.contextPath}/admin/adminPlaceList.do">여행지관리</a>
		</li>
		<li class="nav-item"><a class="nav-link"
			href="${pageContext.request.contextPath}/admin/memberList.do">회원관리</a>
		</li>
	</ul>
	<div class="d-flex justify-content-between mt-5 mb-1 mr-1">
		<h3>여행지목록</h3>
		<button class="btn yellowBtn"
			onclick="location.href='${pageContext.request.contextPath}/admin/adminPlaceForm.do'";>장소
			추가</button>
	</div>
	<table class="table mx-auto table-striped table-hover">
		<tr>
			<th scope="col">번호</th>
			<th scope="col">장소명</th>
			<th scope="col">지역명</th>
			<th scope="col">주소</th>
			<th scope="col">수정 | 삭제</th>
		</tr>
		<c:if test="${not empty placeList}">
			<c:forEach var="place" items="${placeList}">
				<tr data-no="${place.placeNo}">
					<td scope="row">${place.placeNo}</td>
					<td>${place.placeName}</td>
					<td>${place.localName}</td>
					<td>${place.address}</td>
					<td>
						<button class="btn greenBtn" onclick="updatePlace(this);"
							id="updateBtn" data-no="${place.placeNo}">수정</button>
						<button class="btn btn-outline-danger" onclick="deletePlace(this)"
							id="deleteBtn" data-name="${place.placeName}"
							data-no="${place.placeNo}">삭제</button>
					</td>
				</tr>
			</c:forEach>
		</c:if>
	</table>
	${pageBar}
	<form:form name="placeDelFrm"
		action="${pageContext.request.contextPath}/admin/deletePlace.do"
		method="POST">
		<input type="hidden" name="placeNo" value="" />
		<input type="hidden" name="cpage" value="" />
	</form:form>

</div>


<script>
function updatePlace(elem) {
	var no = $(elem).data("no");
	location.href = `${pageContext.request.contextPath}/admin/updatePlace.do?placeNo=\${no}&cpage=${cpage}`;
}

function deletePlace(elem) {
	//POST /demo/deleteDev.do
	var no = $(elem).data("no");
	var name = $(elem).data("name");
	if(confirm("[" + name + "]을(를) 정말 삭제하시겠습니까?")) {
		var $frm = $(document.placeDelFrm);
		$frm.find("[name=placeNo]").val(no);
		$frm.find("[name=cpage]").val(${cpage});
		$frm.submit();
	}
}

$("table tr").click(e =>{
	if(e.target.id == "deleteBtn")
		return false;
	if(e.target.id == "updateBtn")
		return false;
	/* location.href = `${pageContext.request.contextPath}/admin/adminPlaceDetail.do?placeNo=\${no}&cpage=${cpage}`; */
	
});

$("tr[data-no]").click(e => {
	if(e.target.id == "deleteBtn")
		return false;
	if(e.target.id == "updateBtn")
		return false;
	var $tr = $(e.target).parent();
	var no = $tr.data("no");

	location.href = `${pageContext.request.contextPath}/admin/adminPlaceDetail.do?placeNo=\${no}`;
	
	
	
});
</script>
<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>