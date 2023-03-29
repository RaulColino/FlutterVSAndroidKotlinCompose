package com.memshelf.memshelf.presentation.components

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.memshelf.memshelf.domain.entities.Note

@Composable
fun NoteElement(
    note: Note,
    modifier: Modifier = Modifier,
    onDeleteClick: () -> Unit
) {

    Card(
        shape = RoundedCornerShape(7),
        border = BorderStroke(1.dp, Color.Black),
        elevation = 7.dp,
        modifier = modifier
    ) {
        Column(
            verticalArrangement = Arrangement.SpaceBetween,
        ) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(20.dp)
                    .padding(end = 25.dp)
                    .padding(bottom = 50.dp)
            ) {
                Text(
                    text = note.title,
                    style = MaterialTheme.typography.h6,
                    color = MaterialTheme.colors.onSurface,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = note.body,
                    style = MaterialTheme.typography.body1,
                    color = MaterialTheme.colors.onSurface,
                    maxLines = 10,
                    overflow = TextOverflow.Ellipsis
                )
            }

            IconButton(
                onClick = onDeleteClick,
            ) {
                Icon(
                    imageVector = Icons.Default.Delete,
                    contentDescription = "Delete note",
                    tint = MaterialTheme.colors.onSurface
                )
            }

        }

    }

}