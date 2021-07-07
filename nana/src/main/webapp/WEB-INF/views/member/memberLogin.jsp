<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>


<script src="http://code.jquery.com/jquery-latest.min.js"></script>


<!-- bootstrap js: jquery load 이후에 작성할것.-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>

<!-- 카카오로그인 -->
<script type="text/javascript" src="https://developers.kakao.com/sdk/js/kakao.min.js" charset="utf-8"></script>

<!-- 아이콘 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">

<!-- bootstrap css -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">

<!-- 사용자작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/style.css" />



<script>
$(() => {
	$("#loginModal").modal()
					.on('hide.bs.modal', e => {
						console.log(e);
						//location.href = '${header.referer}';
						location.href = '${empty header.referer || fn:contains(header.referer, '/member/memberSearch.do') ? pageContext.request.contextPath : header.referer}';
						
					});
});
$(document).ready(function() {
	$('.modal').on('shown.bs.modal', function(){
		$("input[name=id]").focus();
	});
});

</script>

<style>
div{padding: 10px;}

</style>


</head>
<body> 
	<!-- Modal시작 -->
	<!-- https://getbootstrap.com/docs/4.1/components/modal/#live-demo -->
	<div class="modal fade" id="loginModal" tabindex="-1" role="dialog"
		aria-labelledby="loginModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="loginModalLabel">로그인</h5>
					<i class="bi bi-box-arrow-in-right"></i>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				
				<!-- 소셜로그인폼 -->
				<div class="modal-body" style="border-bottom: 1px solid #e9ecef;">
					<c:if test="${not empty warn}">
						<div class="alert alert-warning alert-dismissible fade show" role="alert">
						  <strong>${warn}</strong>
						  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
						    <span aria-hidden="true">&times;</span>
						  </button>
						</div>
					</c:if>
		        	<h5 class="modal-title" id="loginModalLabel">SNS계정 사용하기</h5>
		        	<a href="${naver_url}"><img width="130" height="30" src="https://developers.naver.com/doc/review_201802/CK_bEFnWMeEBjXpQ5o8N_20180202_7aot50.png"/></a>		        		              
	                <a href="javascript:void(0);" id="googleLoginBtn"><img width="130" height="37" src="${pageContext.request.contextPath}/resources/images/googlesign3.png"/></a>	                
	                <a href="${kakao_url}"><img width="130" height="32" src="${pageContext.request.contextPath}/resources/images/kakao_login_medium_narrow.png"/></a>
		      	</div>
				<script>
					const onClickGoogleLogin = (e) => {
				    	//구글 인증 서버로 인증코드 발급 요청

				 		window.location.replace("https://accounts.google.com/o/oauth2/v2/auth?client_id=739408591416-eml5ffq3tmvluoslv9de803bfnha3mos.apps.googleusercontent.com&redirect_uri=http://www.nanatravel.r-e.kr/nana/member/googleCallback.do&response_type=code&scope=email%20profile%20openid&access_type=offline");
				 		//window.location.replace("https://accounts.google.com/o/oauth2/v2/auth?client_id=739408591416-eml5ffq3tmvluoslv9de803bfnha3mos.apps.googleusercontent.com&redirect_uri=http://18.222.247.91:8080/nana/member/googleCallback.do&response_type=code&scope=email%20profile%20openid&access_type=offline");
				 	}
					const googleLoginBtn = document.getElementById("googleLoginBtn");
					googleLoginBtn.addEventListener("click", onClickGoogleLogin);
				</script>
				
				
				
				
				<!--로그인폼 -->
				<!-- https://getbootstrap.com/docs/4.1/components/forms/#overview -->
				<form:form
					action="${pageContext.request.contextPath}/member/memberLoginProcess.do"
					method="post"
					id="loginFrm">
					<div class="modal-body">
						<c:if test="${param.error != null}">
							<span class="text-danger">아이디 또는 비밀번호가 일치하지 않습니다.</span>
						</c:if>
						<input type="text" class="form-control" name="id"
							placeholder="아이디" required> 
						<br />
						<input
							type="password" class="form-control" name="password"
							placeholder="비밀번호" required>
					</div>
					<div class="modal-footer justify-content-between" style="padding-bottom:0">
						<div>
							<input type="checkbox" class="form-check-input" name="remember-me" id="remember-me"/>
							<!-- 체크시 remember-me=on -->
							<label for="remember-me" class="form-check-label">로그인 정보 저장</label>
						</div>
						<div>
							<a href="${pageContext.request.contextPath}/member/memberSearch.do">아이디/비밀번호 찾기</a>
						</div>
					</div>
					<div>
						<button type="submit" class="btn btn-outline-success btn-block" id="loginBtn">로그인</button>
					</div>
				</form:form>
				<div class="modal-body text-center" style="padding-top:0">
					<div>아직 나홀로 나들이 회원이 아니세요?</div>
					<a href="${pageContext.request.contextPath}/member/memberEnroll.do" style="color:#d39e34;text-decoration:none;">회원가입 하러가기</a>
				</div>
				
			</div>
		</div>
	</div>
	<!-- Modal 끝-->
</body>
</html>
