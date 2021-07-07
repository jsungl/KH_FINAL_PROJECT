<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title"/>
</jsp:include>

<%-- <sec:authentication property="principal.username" var="user_id" /> --%>

<!-- 이모티콘 -->
<script src="https://use.fontawesome.com/6d59a3a344.js"></script>
<!-- 웹소켓 cnd 추가  -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.2/sockjs.js"
	integrity="sha512-3/5zbNJKTwZiPFIUPL9Q6woFGvOluvYq2/rJ+C4sZUTXKhVoY3e6mSTf5RJG01lYX3atqeslmWTsxCXb147x2w=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<!-- stomp.js추가 -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.js"
	integrity="sha512-tL4PIUsPy+Rks1go4kQG8M8/ItpRMvKnbBjQm4d2DQnFwgcBYRRN00QdyQnWSCwNMsoY/MfJY8nHp2CzlNdtZA=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	
<style>
    .card-left{
        height: 150px;
        width: 200px;
        object-fit: cover;
    }
    /* .card-desc{
        text-overflow: ellipsis;
        overflow:hidden;
    } */
    
    .blog-comment::before,
.blog-comment::after,
.blog-comment-form::before,
.blog-comment-form::after{
    content: "";
	display: table;
	clear: both;
}

/* .blog-comment{
    padding-left: 15%;
	padding-right: 15%;
} */

.blog-comment ul{
	list-style-type: none;
	padding: 0;
}

.blog-comment img{
	opacity: 1;
	filter: Alpha(opacity=100);
	-webkit-border-radius: 4px;
	   -moz-border-radius: 4px;
	  	 -o-border-radius: 4px;
			border-radius: 4px;
}

.blog-comment img.avatar {
	position: relative;
	float: left;
	margin-left: 0;
	margin-top: 0;
	width: 65px;
	height: 65px;
}

.blog-comment .post-comments{
	border: 1px solid #eee;
    margin-bottom: 20px;
   /*  margin-left: 85px; */
	margin-right: 0px;
    padding: 10px 20px;
    position: relative;
    -webkit-border-radius: 4px;
       -moz-border-radius: 4px;
       	 -o-border-radius: 4px;
    		border-radius: 4px;
	background: #fff;
	color: #6b6e80;
	position: relative;
}

.blog-comment .meta {
	font-size: 13px;
	color: #aaaaaa;
	padding-bottom: 8px;
	margin-bottom: 10px !important;
	border-bottom: 1px solid #eee;
}

.blog-comment ul.comments ul{
	list-style-type: none;
	padding: 0;
	margin-left: 85px;
}

.blog-comment-form{
	padding-left: 15%;
	padding-right: 15%;
	padding-top: 40px;
}

.blog-comment h3,
.blog-comment-form h3{
	margin-bottom: 40px;
	font-size: 26px;
	line-height: 30px;
	font-weight: 800;
}

.btn-reply{
	color: #f6bd3a;
}

.btn-reply-delete{
	color: #256d69;
}
</style>

<div id="board-container" class="container mt-5 mx-auto">
	
	<h4><span id="badge" class="badge badge-warning"></span> ${board.title}</h4>
	<p class="mb-1">
	<span class="font-weight-bold">${board.id}</span> | <span>${board.writeDate}</span> | 조회수 ${board.readCount}
	<span class="pull-right">
		<c:if test="${not empty id && (id eq board.id || id eq 'admin')}">
			<button type="button" id="btn-board-update" class="btn btn-outline-warning btn-sm">수정</button>
			<button type="button" id="btn-board-del" class="btn btn-outline-danger btn-sm">삭제</button>
		</c:if>
	</span>
	</p>
	<hr style="margin-top: 0.5rem; margin-bottom: 0.5rem;">
	<div class="text-center">
	${board.content}
	</div>
	<hr />
	<div id="courseWrapper" style="display:none;">
		<c:if test="${not empty courseTitle}"><h5>관련 여행코스 : <a style="color:#f6bd3a; text-decoration:none;" href="${pageContext.request.contextPath }/mypage/courseView?no=${board.courseNo}">${courseTitle}</a></h5></c:if>
	</div>
	<c:if test="place != null"></c:if>
	<div id="placeWrapper" style="display:none;">
		<h5 class="mt-4">연관 장소</h5>
		<c:if test="${not empty place }">
			  <div class="card mb-4">
           	<a class="card-block stretched-link" style="color: black; text-decoration: none;" href="${pageContext.request.contextPath}/place/placeDetail.do?placeNo=${place.placeNo}"> 
                  <div class="row p-3">
                      <div class="col-sm-3">
                          <img class="img-fluid card-left" src="${pageContext.request.contextPath }/resources/upload/place/${place.photoList[0].renamedFilename}" alt="">
                      </div>
                      <div class="col-sm-8">
                          <div class="card-body">
                              <h5 class="card-title">${place.placeName}</h5>
                              <p class="card-text">
                                  <i class="fa fa-heart" aria-hidden="true"></i> ${place.placeLikeCount } &nbsp;&nbsp;&nbsp; <i class="fa fa-list" aria-hidden="true"></i> ${place.boardCount}
                              </p>
                              <p class="card-text card-desc">${place.content} </p>
                          </div>
                      </div>
                  </div>
                 </a>
             </div>
		</c:if>
		<c:if test="${empty place }">
			<div class="border p-2">관리자에 의해 삭제된 장소입니다</div>
		</c:if>
	
		
		<hr />
	</div>
	<%-- 좋아요 --%>
	<p>
	<input type="hidden" name="likeVal" value="0" />
	<button id="btn-like" class="btn btn-link" style="color:black; text-decoration:none;">
		<i class="fa fa-thumbs-o-up" aria-hidden="true"></i> 좋아요 <span id="boardLikeCount">${boardLikeCount}</span>개
	</button> | <i class="fa fa-commenting-o" aria-hidden="true"></i> 댓글 ${commentCount}개
	<span class="pull-right">
		<button class="btn btn-outline-warning" onclick="location.href = '${pageContext.request.contextPath }/board/boardList.do'">목록으로</button>
	</span>
	</p>
	
	

	
	<%-- 로그인 한 사용자만 댓글 입력 가능 --%>
	<h4 class="mt-5" style="color: #256d69">댓글</h4>
	<c:if test="${not empty id }">	
		<form class="input-group mb-3" action="${pageContext.request.contextPath}/board/insertBoardComment.do?${_csrf.parameterName}=${_csrf.token}" method="post" name="boardCommentFrm">
			<input type="hidden" name="boardNo" value="${board.boardNo}" />
			<input type="hidden" name="commentLevel" value="1" />
			<input type="hidden" name="commentRef" value="0" />
			<input type="hidden" name="id" value="${id}" />
			 ${id} : &nbsp;<textarea class="form-control" aria-label="등록" name="content" cols="100" rows="3" placeholder="댓글을 남겨주세요"></textarea> &nbsp;
			 
			 <!-- <input type="text" name="content" class="form-control" placeholder="댓글을 남겨주세요" aria-label="Recipient's username" aria-describedby="basic-addon2"> -->
			  <div class="input-group-append">
			  	<input type="submit" class="btn btn-warning" value="등록" />
			  </div>
		</form>
			<hr />
	</c:if>
	
<%-- 댓글&대댓글 --%>
 <c:if test="${not empty commentList}"> 
	<div class="blog-comment">
		<ul class="comments">
		<c:forEach items="${commentList}" var="comment">
		<%-- 댓글 --%>
		<c:if test="${comment.commentLevel eq 1}">
			<li class="clearfix">
			 <!--  <img src="https://bootdey.com/img/Content/user_1.jpg" class="avatar" alt=""> -->
			  <!-- <i class="fa fa-user-circle fa-2x"></i> -->
			  <div class="post-comments" >
			  	<input type="hidden" name="replyNo" value="${comment.replyNo}" />
			      <p class="meta"> <span class="font-weight-bold" style="color:#f6bd3a">${comment.id}</span> | <fmt:formatDate value="${comment.regDate}" pattern="yyyy/MM/dd HH:mm:ss"/>  	<c:if test="${not empty id}">	<span class="pull-right pr-2"><small class="font-weight-bold btn-reply"><i class="fa fa-reply fa-lg" aria-hidden="true"></i></small> &nbsp; &nbsp;<c:if test="${id eq comment.id || id eq 'admin'}">| &nbsp; &nbsp;<small class="font-weight-bold btn-reply-delete" style="color: #f6bd3a"><i class="fa fa-trash fa-lg" aria-hidden="true"></i></small></span></c:if></c:if></p>
			      <p>
			         ${comment.content }
			      </p>
			  </div>
			</li>
		</c:if>
		<c:if test="${comment.commentLevel eq 2 }">
			  <ul class="comments">
			      <li class="clearfix">
			         <!--  <img src="https://bootdey.com/img/Content/user_3.jpg" class="avatar" alt=""> -->
			          <div class="post-comments" style="background-color:#f7f7f9;">
			              <p class="meta"><span class="font-weight-bold" style="color:#256d69">${comment.id}</span> <fmt:formatDate value="${comment.regDate}" pattern="yyyy/MM/dd HH:mm:ss"/> <c:if test="${id eq comment.id || id eq 'admin'}">| <span class="pull-right"><small class="font-weight-bold btn-reply-delete"><i class="fa fa-trash fa-lg" aria-hidden="true"></i></small></span></c:if> </p>
			              <p>
			                  ${comment.content}
			              </p>
			          </div>
			      </li>
			  </ul>
		</c:if>
		
		</c:forEach>
		
		</ul>
	</div>
 </c:if> 


<form name="commentDelFrm" action="${pageContext.request.contextPath }/board/deleteComment.do?${_csrf.parameterName}=${_csrf.token}" method="post">
	<input type="hidden" name="replyNo" value="" />
	<input type="hidden" name="boardNo" value="${board.boardNo}" />
</form>		

<!-- 게시글 삭제 이동 form -->
<form:form name="boardDelFrm" action="${pageContext.request.contextPath }/board/deleteBoard.do" method="post">
	<input type="hidden" name="boardNo" value="${board.boardNo }" />
</form:form>

<!-- 게시글 수정 이동 form -->
<form name="boardUpdateFrm" action="${pageContext.request.contextPath }/board/boardForm.do">
	<input type="hidden" name="boardNo" value="${board.boardNo }" />
</form>

<%-- 로그인 정보 가져오기 --%>
<sec:authentication property="principal" var="principal"/>

</div>

<br><br><br><br><br><br><br><br><br><br><br><br>



<script>
const category = "${board.category}";
const boardNo = "${board.boardNo}";
const id = "${id}";
let isLiked = false; //좋아요 눌렀는지 여부 확인 (false:안누름, true:누름)

const boardLikeNo = Number(${boardLike.no});

$(document).ready(() => {

	//카테고리 별 뱃지 설정
	const $badge = $("#badge");
	if(category === 'review'){
		$badge.text('여행후기');
		$("#courseWrapper").show();
		$("#placeWrapper").show();
	}
	else if(category === 'info'){
		$badge.text('정보공유');
		$("#placeWrapper").show();
	}
	else if(category === 'chat'){
		$badge.text('잡담');
	}

	console.log($("[name=likeVal]").val());

	//좋아요 버튼 스타일 처리
	console.log("boardLikeNo = ", boardLikeNo);
	if(boardLikeNo != 0){
		// 이미 좋아요를 눌렀을 경우 버튼 스타일 변경
		displayBoardLike();
	}
	
});

function displayBoardLike(){
	$("[name=likeVal]").val(1);
	$("#btn-like").addClass("text-danger");
	
}

function displayBoardUnlike(){
	$("[name=likeVal]").val(0);
	$("#btn-like").removeClass("text-danger");
	
}

// 좋아요 클릭
$("#btn-like").click((e) => {
	const $btnLike = $(e.target);
	const likeValVal = $("[name=likeVal]").val(); 
	
	if(id == null || id === ""){
		alert("로그인이 필요합니다.");
	}else{

		$.ajax({
			url: "${pageContext.request.contextPath}/board/likeBoard.do?${_csrf.parameterName}=${_csrf.token}",
			type: "post",
			data: {id, likeValVal, boardNo},
			success: (data) => {
				console.log(data);
				if(data.code === 'insert'){
					displayBoardLike();
				}
				else if(data.code === 'delete'){
					displayBoardUnlike();
				} 
				$("#boardLikeCount").text(data.cnt);
				
			},
			error: console.log
		});
		
	}
	
});


//대댓글 달기 (클릭 시 등록 폼 동적으로 만들기)
$(".btn-reply").click((e) => {
	let $div = $(e.target).parents(".post-comments");
	//console.log($div);
	const replyNo = $div.find("[name=replyNo]").val();

	let html = `<form style="width:90%; float:right;" class="input-group mb-3" action="${pageContext.request.contextPath}/board/insertBoardComment.do?${_csrf.parameterName}=${_csrf.token}" method="post" name="boardCommentFrm">
		<input type="hidden" name="boardNo" value="${board.boardNo}" />
		<input type="hidden" name="commentLevel" value="2" />
		<input type="hidden" name="commentRef" value="\${replyNo}" />
		<input type="hidden" name="id" value="${id}" />
		 <textarea class="form-control" aria-label="등록" name="content" cols="100" rows="3" placeholder="대댓글을 입력하세요"></textarea> &nbsp;
		  <div class="input-group-append">
		  	<input type="submit" class="btn btn-secondary" value="등록" />
		  </div>
	</form>`;

	//댓글창 슬라이딩 (안됨)
	//$(html).insertAfter($div).slideDown();

	//댓글창 한번만 띄우기
	$($(e.target).parent()).off('click');
});

//댓글 대댓글 삭제하기
$(".btn-reply-delete").click((e) => {
	if(confirm("댓글을 삭제하시겠습니까?")){
		const $commentDelFrm = $("[name=commentDelFrm]");
		const $div = $(e.target).parents(".post-comments");
		const replyNo = $div.find("[name=replyNo]").val();
		
		$commentDelFrm.find("[name=replyNo]").val(replyNo);
		$commentDelFrm.submit();
	}
});

//게시글 삭제
$("#btn-board-del").click((e) => {
	if(confirm("게시글을 삭제하시겠습니까?")){
		$("[name=boardDelFrm]").submit();
	}
});

//게시글 수정
$("#btn-board-update").click((e) => {
	$("[name=boardUpdateFrm]").submit();
});

/* 웹소켓 관련 */

//댓글
/* $("[name=commentDelFrm]").submit(function(){

} */

	/* 실시간알림용 웹소켓 */
	
	const sock = new SockJS(`http://\${location.host}${pageContext.request.contextPath}/notification`);

	sock.onopen = e => {
		console.log("onopen : ", e);
	}

	sock.onmessage = function(e) {
		console.log("onmessage : ", e);
		/* const {data} = e;
		console.log("data : ", data); */
	}

	sock.onerror = e => {
		console.log("oneeror : ", e);
	}

	sock.onclose = e => {
		console.log("onclose : ", e);
	}
	
/**
 * 좋아요 버튼을 눌렀을 때 웹 소켓 처리
 */
$("#btn-like").on('click', function(){

	const likeValVal = $("[name=likeVal]").val(); 

	//좋아요를 할 때만
	if(likeValVal == 0) {
		//알림 보내기
	let senderName = "${principal.name}"; //스크랩 버튼을 누른 사람
	let receverId = "${board.id}";
	let boardNo = ${board.boardNo};
	let type = "like";
	var title = "${board.title}";
	title = cutByLen(title, 16);
	title += "...";
	console.log(title);
	
	const alramMessage = {
		"type" : type,
		"senderName" : senderName,
		"receverId" : receverId,
		"boardNo" : boardNo,
		"messageContent" : senderName + "님이 [" + title + "]을(를) 좋아요 했습니다.",
		"time" : Date.now()
	};
	
	console.log(alramMessage);
	
		//알림 DB 저장
	 	$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/noti/saveNoti.do?${_csrf.parameterName}=${_csrf.token}",
				data: JSON.stringify(alramMessage),
				contentType: "application/json; charset=utf-8",
				dataType: "text",
				success: (data) => {
					if(sock) {
						let socketMsg = senderName + "," + receverId + "," + boardNo + "," + type;
						console.log(socketMsg)
						sock.send(socketMsg);
					}
					console.log(data);
	 		},
	 		error : console.log
		});
	}
});

/* 문자열 자르기 함수 */
function cutByLen(str, maxByte) {
	for(b=i=0; c=str.charCodeAt(i);) {
		b+=c>>7?2:1;
			if (b > maxByte)
				break;
		i++;
	}
	return str.substring(0,i);
}


/**
 * 댓글을 달았을 때 웹 소켓 처리
 */

 
</script>


<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>