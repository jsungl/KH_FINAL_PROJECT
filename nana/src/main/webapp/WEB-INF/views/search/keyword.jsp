<%@page import="java.util.ArrayList"%>
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
	// 입력한 검색어 받아옴
	String keyword = (String)request.getAttribute("searchKeyword");
	if(!(keyword == null || keyword.trim().isEmpty())){
		// session의 keywordList를 받아옴 -> null point 발생.. 
		List<String> list = (ArrayList)session.getAttribute("keywordList");
		// list가 없으면 새로 생성
		if(list == null)
			list = new ArrayList<>();
		// 리스트에 검색한 키워드 추가
		list.add(keyword);
		// 검색 키워드가 추가된 리스트를 세션에 담음
		session.setAttribute("keywordList", list);
	}
	
%> 
<%-- content --%>

<style>
    .card-left{
	    min-height: 150px;
	    min-width: 150px;
    	height: 15vw;
    	width: 15vw;
    	object-fit: cover;
	}	
     .card-body {overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
</style>

<div class="container">

	<div class="row mt-3">

		<!-- 장소 리스트 -->
		<div class="col mx-2">


			<!-- 정렬 select -->
			<!-- <nav class="navbar navbar-light justify-content-between"> -->
				<!-- <a class="navbar-brand"></a> --> 
				<select name="sort" id="sort">
                        <option value="like-count" ${sort eq 'like-count' ? 'selected' : '' }>찜 많은 순</option>
                        <option value="board-count" ${sort eq 'board-count' ? 'selected' : '' }>게시글 많은 순</option>
                        <option value="place-name" ${sort eq 'place-name' ? 'selected' : '' }>이름순</option>
                    </select>
			<!-- </nav> -->
	
			<%-- 리스트 --%>
			<c:if test="${empty searchPlace}"> <h2 style="text-align: center;">검색된 장소가 없습니다...</h2></c:if>
			<c:if test="${searchPlace != null}">
				<c:forEach items="${searchPlace}" var="place">
					<!-- 리스트 시작 -->
					<div class="card md-4" id="cardDiv">
						<a class="card-block stretched-link"
							style="color: black; text-decoration: none;"
							href="${pageContext.request.contextPath}/place/placeDetail.do?placeNo=${place.placeNo}">
							<div class="row p-3">
								<div class="col-lg-4">
									<img class="img-fluid card-left" 
									 	 src="${pageContext.request.contextPath}/resources/upload/place/${place.photoList[0].renamedFilename}">
								</div>
								<div class="col-lg-8">
									<div class="card-body">
										<h5 class="card-title">
										<c:if test="${place.fromUser == 1}">
		                               	<span class="badge badge-warning">유저등록</span>
		                               </c:if>
		                               	${place.placeName}
		                               </h5>
		                               <p class="card-text">
		                                   <i class="fa fa-heart" aria-hidden="true"></i> ${place.placeLikeCount } &nbsp;&nbsp;&nbsp; <i class="fa fa-list" aria-hidden="true"></i> ${place.boardCount }
		                               </p>
										
										<p class="card-text card-desc">${place.content}</p>
									</div>
								</div>
							</div>
						</a>
					</div>
					<!-- 리스트 끝 -->
				</c:forEach>
			</c:if>
		</div>
	</div>
</div>

<script>
let keyword = "${searchKeyword}";
$("[name=sort]").change((e) => {
	const sort = $(e.target).val();
	location.href=`${pageContext.request.contextPath}/search/keyword.do?sort=\${sort}&searchKeyword=\${keyword}`;
});
</script>


	
	
	
<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>