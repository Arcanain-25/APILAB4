package com.edulearn.app.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.edulearn.app.ui.course.CourseScreen
import com.edulearn.app.ui.home.HomeScreen

object Routes {
    const val HOME = "home"
    const val COURSE = "course"
}

@Composable
fun AppNav() {
    val nav = rememberNavController()
    NavHost(navController = nav, startDestination = Routes.HOME) {
        composable(Routes.HOME) {
            HomeScreen(onOpenCourse = { nav.navigate(Routes.COURSE) })
        }
        composable(Routes.COURSE) {
            CourseScreen(onBack = { nav.popBackStack() })
        }
    }
}
