package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import action.Action;
import action.CodeAction;
import action.CodeJoinAction;
import action.CodeJoinBeforeAction;
import action.CreateProject2Action;
import action.CreateProjectAction;
import action.CreateProjectFinalAction;
import action.FileAction;
import action.FirstPageAction;
import action.HomeAction;
import action.JoinAction;
import action.LoginAction;
import action.LoginPageAction;
import action.MainBoardAction;
import action.MainInventoryAction;
import action.MainOutlineAction;
import action.MemoAction;
import action.MessageAction;
import action.MyWorkspaceAction;
import action.OtherProfileAction;
import action.ProfilePageAction;
import action.ResendCodeAction;

// http://localhost:9090/AsanaMVC/Controller?command=home
	
@WebServlet("/Controller")
public class ExController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String command = request.getParameter("command");
		System.out.println("command = " + command);
		Action action = null;
		switch(command) {
		case "home" : action = new HomeAction(); break;
		case "other_profile" : action = new OtherProfileAction(); break;
		case "profile_page" : action = new ProfilePageAction(); break;
		case "create_project" : action = new CreateProjectAction(); break;
		case "create_project2" : action = new CreateProject2Action(); break;
		case "create_project_action" : action = new CreateProjectFinalAction(); break;
		case "my_workspace" : action = new MyWorkspaceAction(); break;
		case "file" : action = new FileAction(); break;
		case "memo" : action = new MemoAction(); break;
		case "message" :  action = new MessageAction(); break;
		case "first_page" : action = new FirstPageAction(); break;
		case "login" : action = new LoginPageAction(); break;
		case "join" : action = new JoinAction(); break;
		case "code_join_before" : action = new CodeJoinBeforeAction(); break;
		case "login_action" : action = new LoginAction(); break;
		case "code_join" : action = new CodeJoinAction(); break;
		case "code_action" : action = new CodeAction(); break;
		case "resend_code" : action = new ResendCodeAction(); break;
		case "main_outline" : action = new MainOutlineAction(); break;
		case "main_inventory" : action = new MainInventoryAction(); break;
		case "main_board" : action = new MainBoardAction(); break;
		}
		action.execute(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		doGet(request, response);
	}

}
