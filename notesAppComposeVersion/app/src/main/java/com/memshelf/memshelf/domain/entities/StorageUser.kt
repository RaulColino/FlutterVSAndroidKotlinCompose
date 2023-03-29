package com.memshelf.memshelf.domain.entities

import androidx.compose.ui.graphics.Color
import androidx.room.Entity
import androidx.room.PrimaryKey
import com.memshelf.memshelf.ui.theme.MemBlue
import com.memshelf.memshelf.ui.theme.MemGreen
import com.memshelf.memshelf.ui.theme.MemOrange
import com.memshelf.memshelf.ui.theme.MemPurple


data class StorageUser(
    val id: String,
    val name: String = "unknown",
    val notes: List<RemoteNote>
) {

    constructor() : this("","", emptyList<RemoteNote>())

}