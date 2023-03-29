package com.memshelf.memshelf.presentation.utils.navigation

sealed class Screen(val route: String){
    object HomeScreen: Screen( "home")
    object NoteDetailScreen: Screen("note_detail")
    object LoginScreen: Screen("login")
    object SignupScreen: Screen("signup")
}
