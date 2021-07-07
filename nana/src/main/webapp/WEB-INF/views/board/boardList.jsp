<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.sql.*" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypage.css" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<!-- pagebar style -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/button.css" />

<style>
	#board-container {
		text-align: center;
	}
</style>

<section id="board-container" class="container mt-3 pt-2" >
<div>
<h2 class="mx-auto"><i class="fa fa-users" style="color:#ffc107;" aria-hidden="true"></i> 커뮤니티</h2>
<p class="mx-auto text-secondary" style="font-size:15px;">여러분의 혼행 정보를 공유해주세요</p>
</div>
	<input type="button" value="작성하기" id="btn-add" class="btn btn-outline-warning mb-2" onclick="location.href='${pageContext.request.contextPath}/board/boardForm.do'" style="float: left;" style="cursor:pointer"/>
	<table id="tbl-board" class="table table-striped table-hover">
		<tr>
			<th scope="col">작성자</th>
			<th scope="col">번호</th>
			<th scope="col">카테고리</th>
			<th scope="col">제목</th>
			<th scope="col">조회수</th>
  	    	<th scope="col">좋아요</th>
      		<th scope="col">작성일</th>
    	</tr>
    	
    	<c:set var="now" value="<%=new java.util.Date()%>" /><!-- 현재시간 -->
    	<c:if test="${not empty boardList}">
				<c:forEach items="${boardList}" var="board"  varStatus="status">
					<tr data-id="${board.id}">
						<td scope="row" style="cursor:pointer" onclick="location.href = '${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${board.boardNo}'">${board.id}</td>
						<td scope="row" style="cursor:pointer" onclick="location.href = '${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${board.boardNo}'">${board.boardNo}</td>
						<c:choose>
						<c:when test="${board.category eq 'chat'}">
						<td scope="row" style="cursor:pointer" onclick="location.href = '${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${board.boardNo}'">잡담</td>
						</c:when>
						<c:when test="${board.category eq 'info'}">
						<td scope="row" style="cursor:pointer" onclick="location.href = '${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${board.boardNo}'">정보공유</td>
						</c:when>
						<c:when test="${board.category eq 'review'}">
						<td scope="row" style="cursor:pointer" onclick="location.href = '${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${board.boardNo}'">여행후기</td>
						</c:when>
						</c:choose>
						<c:choose>
						<c:when test="${now.date - board.writeDate.date ge 0 && now.date - board.writeDate.date le 2}">
							<td scope="row" style="cursor:pointer; text-align:left;" onclick="location.href = '${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${board.boardNo}'">${board.title}&nbsp;<img src="${pageContext.request.contextPath}/resources/images/new.png" width="12px" alt="new"/></td>
						</c:when>
						<c:otherwise>
							<td scope="row" style="cursor:pointer; text-align:left;" onclick="location.href = '${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${board.boardNo}'">${board.title}</td>
						</c:otherwise>
						</c:choose>
						<td scope="row" style="cursor:pointer" onclick="location.href = '${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${board.boardNo}'">${board.readCount}</td>
						<td scope="row" style="cursor:pointer" onclick="location.href = '${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${board.boardNo}'">${board.likeCount}</td>
						<td scope="row" style="cursor:pointer" onclick="location.href = '${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${board.boardNo}'">${board.writeDate}</td>
					</tr>
				</c:forEach>
			</c:if>
	</table>
	${boardPageBar}
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>