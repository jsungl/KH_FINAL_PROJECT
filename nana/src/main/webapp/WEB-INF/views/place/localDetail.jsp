<%@page import="java.io.IOException"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.Map"%>
<%@page import="com.kh.nana.place.model.vo.LocalPhoto"%>
<%@page import="com.kh.nana.place.model.vo.Place"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>

<% 
//List<Place> placeList = (List<Place>)request.getAttribute("placeList");
List<Map<String, Object>> placeList = (List<Map<String, Object>>)request.getAttribute("placeList");
List<LocalPhoto> localPhotoList = (List<LocalPhoto>)request.getAttribute("localPhotoList");
List<Map<String, Object>> categoryList = (List<Map<String, Object>>) request.getAttribute("categoryList");
String serviceKey = (String)request.getAttribute("serviceKey");

%>


<style>
.carousel-item>img {
	height: 25vw;
	/* height: 500px; */
	object-fit: cover;
}

.card-img-top {
	/* height: 15vw; */
	height: 200px;
	object-fit: cover;
}
</style>

<div class="container mt-3">
<%-- 	<h3 class="mb-2"><%= placeList.get(0).getLocalName() %></h3> --%>
	<h1 class="mb-2">${localName}</h1>
	<ul class="nav nav-pills nav-fill">
		<!-- <li class="nav-item"><a class="nav-link active" href="">홈</a></li> -->
	
	<c:forEach items="${categoryList}" var="category">
		<li class="nav-item"><a class="nav-link text-info" href="${pageContext.request.contextPath}/place/categoryList.do?categoryCode=${category.categoryCode}&localCode=${localCode}&sort=place-name">${category.categoryName}</a>
	</c:forEach>
	</ul>

	<!-- 회전목마+날씨+미세먼지 -->
	<!-- <div class="row mt-2" > -->
		<!-- <div class="col-lg-8"> -->
		
			<div id="carouselExampleIndicators" class="carousel slide mt-3 mb-5"
				data-ride="carousel">
				<ol class="carousel-indicators">
					<li data-target="#carouselExampleIndicators" data-slide-to="0"
						class="active"></li>
					<li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
					<li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
				</ol>
				<div class="carousel-inner">
				<!-- class가 변해야해서 반복문 못씀  -->
					<div class="carousel-item active">
						<img
							src="<%= localPhotoList.get(0).getLocalImgUrl() %>"
							class="d-block w-100" alt="...">
					</div>
					<div class="carousel-item">
						<img
							src="<%= localPhotoList.get(1).getLocalImgUrl() %>"
							class="d-block w-100" alt="...">
					</div>
					<div class="carousel-item">
						<img
							src="<%= localPhotoList.get(2).getLocalImgUrl() %>"
							class="d-block w-100" alt="...">
					</div>
				</div>
				<a class="carousel-control-prev" href="#carouselExampleIndicators"
					role="button" data-slide="prev"> <span
					class="carousel-control-prev-icon" aria-hidden="true"></span> <span
					class="sr-only">Previous</span>
				</a> <a class="carousel-control-next" href="#carouselExampleIndicators"
					role="button" data-slide="next"> <span
					class="carousel-control-next-icon" aria-hidden="true"></span> <span
					class="sr-only">Next</span>
				</a>
			</div>
		<!-- </div> -->
		
<!-- 
		<div class="col-lg-4">

			<div class="row">
				<div class="card">
					<div class="card-body">
						<h5 class="card-title">날씨</h5>
						<h6 class="card-subtitle mb-2 text-muted">Card subtitle</h6>
						<p class="card-text">Some quick example text to build on the
							card title and make up the bulk of the card's content.</p>
						<a href="#" class="card-link">Card link</a> <a href="#"
							class="card-link">Another link</a>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="card">
					<div class="card-body">
						<h5 class="card-title">미세먼지</h5>
						<h6 class="card-subtitle mb-2 text-muted">Card subtitle</h6>
						<p class="card-text">Some quick example text to build on the
							card title and make up the bulk of the card's content.</p>
						<a href="#" class="card-link">Card link</a> <a href="#"
							class="card-link">Another link</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	-->
	
	<!-- 카테고리 시작 -->
	
	<% for(Map<String, Object> category : categoryList){ %>
	<a class="d-block" style="margin-top: 80px; text-decoration:none; text-align:center;" href="${pageContext.request.contextPath}/place/categoryList.do?categoryCode=<%= category.get("categoryCode") %>&localCode=${localCode}&sort=place-name"><span style="font-size: 1.5em; color:black;"><%= category.get("categoryName") %></span></a>
	<div class="row">
		<%
		int cnt = 0;
		for(int i = 0; i < placeList.size(); i++){ 
			
			Map<String, Object> map = placeList.get(i);
			if(category.get("categoryCode").equals(map.get("categoryCode"))){
			cnt++;
		%> <!-- 3개만 표시 -->
		<div class="col-lg-4 mt-3">
			<div class="card">
				<a class="card-block stretched-link" style="color: black; text-decoration: none;" href="${pageContext.request.contextPath}/place/placeDetail.do?placeNo=<%= Integer.parseInt(String.valueOf(map.get("placeNo"))) %>">
				<img class="card-img-top"
					src="${pageContext.request.contextPath }/resources/upload/place/<%= map.get("renamedFilename") %>"
					alt="Card image cap">
				<div class="card-body">
					<h5 class="card-title"><%= (String)map.get("placeName") %></h5>
					<p class="card-text">
						<i class="fa fa-heart" aria-hidden="true"></i> <%= Integer.parseInt(String.valueOf(map.get("placeLikeCount"))) %> &nbsp;&nbsp;&nbsp; <i class="fa fa-list" aria-hidden="true"></i> <%= Integer.parseInt(String.valueOf(map.get("boardCount"))) %>
					</p>
				</div>
				</a>
			</div>
		</div>
			<% }
			if(cnt == 3) break;
			} %>
		</div>
	<% } %>
	
	<!-- 카테고리 끝 -->
	

</div>

<script>
$(document).ready(() => {
	const localCode = "${localCode}";
	console.log(localCode);

	// controller를 proxy로 써서 api응답 받아오기
	$.ajax({
		url: "${pageContext.request.contextPath}/place/weather.do",
		data: {
				localCode : localCode
			},
		success(data){
			console.log(data);
		},
		error: console.log
	});
});
</script> 

<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
