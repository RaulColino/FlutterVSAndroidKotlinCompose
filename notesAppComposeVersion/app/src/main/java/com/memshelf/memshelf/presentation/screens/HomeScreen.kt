package com.memshelf.memshelf.presentation.screens

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.GridCells
import androidx.compose.foundation.lazy.LazyVerticalGrid
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ExitToApp
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.memshelf.memshelf.presentation.components.NoteElement
import com.memshelf.memshelf.presentation.utils.navigation.Screen
import com.memshelf.memshelf.presentation.view_models.home.HomeEvent
import com.memshelf.memshelf.presentation.view_models.home.HomeViewModel
import com.memshelf.memshelf.presentation.view_models.login.LoginViewModel
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch

@ExperimentalFoundationApi
@Composable
fun HomeScreen(
    navController: NavController,
    viewModel: HomeViewModel = hiltViewModel()
) {
    //val state = viewModel.state.value
    val notes = viewModel.notes.value
    val scaffoldState = rememberScaffoldState()
    val scope = rememberCoroutineScope()

    LaunchedEffect(key1 = true) {
        viewModel.eventFlow.collectLatest { event ->
            when (event) {
                is HomeViewModel.UiEvent.SignOutRequested -> {
                    navController.navigate(Screen.LoginScreen.route)
                }
            }
        }
    }

    Scaffold(
        floatingActionButton = {
            FloatingActionButton(
                onClick = {
                    navController.navigate(Screen.NoteDetailScreen.route)
                },
                backgroundColor = Color.Black
            ) {
                Icon(
                    imageVector = Icons.Default.Add,
                    contentDescription = "Add new note",
                    tint = Color.White
                )
            }
        },
        scaffoldState = scaffoldState,
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(20.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "My notes",
                    style = MaterialTheme.typography.h4
                )
                IconButton(
                    onClick = {
                        viewModel.onEvent(HomeEvent.SignOut)
                    },
                ) {
                    Icon(imageVector = Icons.Default.ExitToApp, contentDescription = "Sign out")
                }
            }
            Spacer(modifier = Modifier.height(20.dp))
            Column(modifier = Modifier.fillMaxWidth()) {
                LazyVerticalGrid(
                    cells = GridCells.Fixed(2),
                    contentPadding = PaddingValues(start = 10.dp, end = 10.dp, bottom = 10.dp),
                    modifier = Modifier.fillMaxHeight()
                ) {
                    items(notes) { note ->
                        NoteElement(
                            note = note,
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(8.dp)
                                .clickable {
                                    navController.navigate(
                                        Screen.NoteDetailScreen.route
                                                + "?noteId=${note.id}&noteColor=${note.color}"
                                    )
                                },
                            onDeleteClick = {
                                viewModel.onEvent(HomeEvent.DeleteNote(note))
                                scope.launch {
                                    val result = scaffoldState.snackbarHostState.showSnackbar(
                                        message = "Note deleted",
                                        actionLabel = "Undo"
                                    )
                                    if (result == SnackbarResult.ActionPerformed) {
                                        viewModel.onEvent(HomeEvent.RestoreNote)
                                    }
                                }
                            }
                        )

                        Spacer(modifier = Modifier.height(20.dp))

                    }
                }
            }
        }
    }
}