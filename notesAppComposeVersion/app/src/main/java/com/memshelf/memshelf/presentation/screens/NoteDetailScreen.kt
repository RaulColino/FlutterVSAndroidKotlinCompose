package com.memshelf.memshelf.presentation.screens

import androidx.compose.animation.Animatable
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Save
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.memshelf.memshelf.domain.entities.Note
import com.memshelf.memshelf.presentation.components.TextFieldWithHint
import com.memshelf.memshelf.presentation.utils.navigation.Screen
import com.memshelf.memshelf.presentation.view_models.NoteDetail.NoteDetailEvent
import com.memshelf.memshelf.presentation.view_models.NoteDetail.NoteDetailViewModel
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch

@Composable
fun NoteDetailScreen(
    navController: NavController,
    noteColor: Int,
    viewModel: NoteDetailViewModel = hiltViewModel()
) {
    val titleState = viewModel.noteTitle.value
    val bodyState = viewModel.noteBody.value

    //to show snackbars
    val scaffoldState = rememberScaffoldState()

    val noteBackgroundAnimatable = remember {
        Animatable(
            Color(if (noteColor != -1) noteColor else viewModel.noteColor.value)
        )
    }
    val scope = rememberCoroutineScope()

    LaunchedEffect(key1 =true){
        viewModel.eventFlow.collectLatest { event ->
             when(event){
                 is NoteDetailViewModel.UiEvent.ShowSnackbar->{
                    scaffoldState.snackbarHostState.showSnackbar(
                        message =  event.message
                    )
                 }
                 is NoteDetailViewModel.UiEvent.SaveNote->{
                     navController.navigate(Screen.HomeScreen.route)
                 }
             }
        }
    }

    Scaffold(
        floatingActionButton = {
            FloatingActionButton(
                onClick = {
                    viewModel.onEvent(NoteDetailEvent.SaveNote)
                },
                backgroundColor = Color.Black
            ) {
                Icon(imageVector = Icons.Default.Save, contentDescription = "Save note", tint = Color.White)
            }
        },
        scaffoldState = scaffoldState
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(Color.White)
                .padding(20.dp)
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(10.dp),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Note.noteColors.forEach { color ->
                    val colorInt = color.toArgb()
                    Box(
                        modifier = Modifier
                            .size(40.dp)
                            .clip(CircleShape)
                            .background(color)
                            .border(
                                width = 3.dp,
                                color = if (viewModel.noteColor.value == colorInt) {
                                    Color.Black
                                } else Color.Transparent,
                                shape = CircleShape
                            )
                            .clickable {
                                scope.launch {
                                    noteBackgroundAnimatable.animateTo(
                                        targetValue = Color(colorInt),
                                        animationSpec = tween(
                                            durationMillis = 500
                                        )
                                    )
                                }
                                viewModel.onEvent(NoteDetailEvent.ChangeColor(colorInt))
                            }
                    )
                }
            }
            Spacer(modifier = Modifier.height(20.dp))
            TextFieldWithHint(
                text = titleState.text,
                hint = titleState.hintText,
                onValueChange = {
                    viewModel.onEvent(NoteDetailEvent.EnteredTitleText(it))
                },
                onFocusChange = {
                    viewModel.onEvent(NoteDetailEvent.ChangeTitleTextFocus(it))
                },
                isHintVisible = titleState.isHintVisible,
                isSingleLine = true,
                textStyle = MaterialTheme.typography.h4
            )
            Spacer(modifier = Modifier.height(20.dp))
            TextFieldWithHint(
                text = bodyState.text,
                hint = bodyState.hintText,
                onValueChange = {
                    viewModel.onEvent(NoteDetailEvent.EnteredBodyText(it))
                },
                onFocusChange = {
                    viewModel.onEvent(NoteDetailEvent.ChangeBodyTextFocus(it))
                },
                isHintVisible = bodyState.isHintVisible,
                textStyle = MaterialTheme.typography.body1,
                modifier = Modifier.fillMaxHeight()
            )
        }
    }
}