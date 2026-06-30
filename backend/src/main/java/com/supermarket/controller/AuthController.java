package com.supermarket.controller;

import com.supermarket.common.Result;
import com.supermarket.dto.LoginDTO;
import com.supermarket.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 认证控制器
 */
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @GetMapping("/health")
    public Result<String> health() {
        return Result.success("OK");
    }

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody LoginDTO loginDTO) {
        Map<String, Object> data = userService.login(loginDTO.getUsername(), loginDTO.getPassword());
        return Result.success("登录成功", data);
    }
}