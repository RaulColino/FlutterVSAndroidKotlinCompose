package com.memshelf.memshelf

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.runtime.Composable
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.google.firebase.auth.FirebaseAuth
import com.memshelf.memshelf.presentation.screens.HomeScreen
import com.memshelf.memshelf.presentation.screens.LoginScreen
import com.memshelf.memshelf.presentation.screens.NoteDetailScreen
import com.memshelf.memshelf.presentation.screens.SignupScreen
import com.memshelf.memshelf.presentation.utils.navigation.Screen

//The main Navigation composable which will handle all the navigation stack.

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun NavComposeApp() {

    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination =
        if (FirebaseAuth.getInstance().currentUser == null)
            Screen.LoginScreen.route
        else
            Screen.HomeScreen.route
    ) {
        composable(route = Screen.LoginScreen.route) {
            LoginScreen(navController = navController)
        }

        composable(route = Screen.SignupScreen.route) {
            SignupScreen(navController = navController)
        }

        composable(route = Screen.HomeScreen.route) {
            HomeScreen(navController = navController)
        }

        composable(
            route = Screen.NoteDetailScreen.route + "?noteId={noteId}&noteColor={noteColor}",
            arguments = listOf(
                navArgument(
                    name = "noteId"
                ) {
                    type = NavType.IntType
                    defaultValue = -1
                },
                navArgument(
                    name = "noteColor"
                ) {
                    type = NavType.IntType
                    defaultValue = -1
                },
            )
        ) {
            val color = it.arguments?.getInt("noteColor") ?: -1
            NoteDetailScreen(
                navController = navController,
                noteColor = color
            )
        }
    }
}