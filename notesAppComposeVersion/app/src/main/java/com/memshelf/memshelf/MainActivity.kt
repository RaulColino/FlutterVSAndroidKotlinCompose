package com.memshelf.memshelf

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.ktx.Firebase
import com.memshelf.memshelf.presentation.screens.HomeScreen
import com.memshelf.memshelf.presentation.screens.LoginScreen
import com.memshelf.memshelf.presentation.screens.NoteDetailScreen
import com.memshelf.memshelf.presentation.utils.navigation.Screen
import com.memshelf.memshelf.ui.theme.MemshelfTheme
import dagger.hilt.android.AndroidEntryPoint

@ExperimentalFoundationApi
@AndroidEntryPoint
class MainActivity : ComponentActivity() {

    //private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        //auth = FirebaseAuth.getInstance()
        FirebaseApp.initializeApp(this)
        setContent{
            NavComposeApp()
        }
        setContent {
            MemshelfTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    //modifier = Modifier.fillMaxSize(),
                    color = Color.White
                ) {
                    NavComposeApp()
                }
            }
        }
    }
}
