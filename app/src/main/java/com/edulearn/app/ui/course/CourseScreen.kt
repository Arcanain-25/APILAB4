package com.edulearn.app.ui.course

import android.app.Activity
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowLeft
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowRight
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.MenuBook
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Schedule
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.foundation.Image
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.view.WindowInsetsControllerCompat
import com.edulearn.app.R
import com.edulearn.app.data.Lesson
import com.edulearn.app.data.courseLessons
import com.edulearn.app.ui.theme.CardWhite
import com.edulearn.app.ui.theme.ChipScrim
import com.edulearn.app.ui.theme.CoverPurple
import com.edulearn.app.ui.theme.LockedGray
import com.edulearn.app.ui.theme.Orange
import com.edulearn.app.ui.theme.PageBg
import com.edulearn.app.ui.theme.StarGold
import com.edulearn.app.ui.theme.TabInactive
import com.edulearn.app.ui.theme.TextMuted
import com.edulearn.app.ui.theme.TextPrimary
import com.edulearn.app.ui.theme.TextSecondary

@Composable
fun CourseScreen(onBack: () -> Unit) {
    val view = LocalView.current
    SideEffect {
        val window = (view.context as Activity).window
        WindowInsetsControllerCompat(window, view).isAppearanceLightStatusBars = true
    }

    var tab by remember { mutableIntStateOf(0) }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(CardWhite)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .statusBarsPadding()
                .verticalScroll(rememberScrollState())
                .padding(bottom = 108.dp)
        ) {
            TopBar(onBack)
            Spacer(Modifier.height(8.dp))
            CoverCard()
            Spacer(Modifier.height(20.dp))
            CourseMeta()
            Spacer(Modifier.height(18.dp))
            Tabs(selected = tab, onSelect = { tab = it })
            Spacer(Modifier.height(8.dp))
            if (tab == 0) {
                courseLessons.forEach { LessonRow(it) }
            } else {
                DescriptionBlock()
            }
        }

        BottomBar(
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .navigationBarsPadding()
        )
    }
}

@Composable
private fun TopBar(onBack: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 8.dp, vertical = 6.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = Icons.AutoMirrored.Filled.KeyboardArrowLeft,
            contentDescription = "Back",
            tint = TextPrimary,
            modifier = Modifier
                .size(40.dp)
                .clickable(onClick = onBack)
                .padding(4.dp)
        )
        Text(
            "Course Overview",
            color = TextPrimary,
            fontSize = 20.sp,
            fontWeight = FontWeight.Bold
        )
    }
}

@Composable
private fun CoverCard() {
    Box(
        modifier = Modifier
            .padding(horizontal = 20.dp)
            .fillMaxWidth()
            .height(196.dp)
            .clip(RoundedCornerShape(22.dp))
    ) {
        Image(
            painter = painterResource(R.drawable.lab24),
            contentDescription = "Spoken English",
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
        Box(
            modifier = Modifier
                .align(Alignment.Center)
                .size(54.dp)
                .shadow(8.dp, CircleShape)
                .clip(CircleShape)
                .background(Orange),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = Icons.Filled.PlayArrow,
                contentDescription = "Play",
                tint = Color.White,
                modifier = Modifier.size(32.dp)
            )
        }
    }
}

@Composable
private fun CourseMeta() {
    Column(modifier = Modifier.padding(horizontal = 22.dp)) {
        Text(
            "React Front To back",
            color = TextPrimary,
            fontSize = 22.sp,
            fontWeight = FontWeight.Bold
        )
        Spacer(Modifier.height(8.dp))
        Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(
                Icons.Filled.Schedule,
                contentDescription = null,
                tint = TextMuted,
                modifier = Modifier.size(16.dp)
            )
            Spacer(Modifier.width(6.dp))
            Text(
                "6h 30min  ·  7 lessons",
                color = TextSecondary,
                fontSize = 13.sp
            )
            Spacer(Modifier.weight(1f))
            Box(
                modifier = Modifier
                    .clip(RoundedCornerShape(8.dp))
                    .background(PageBg)
                    .padding(horizontal = 8.dp, vertical = 4.dp)
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        Icons.Filled.Star,
                        contentDescription = null,
                        tint = StarGold,
                        modifier = Modifier.size(14.dp)
                    )
                    Spacer(Modifier.width(4.dp))
                    Text("4.9", color = TextPrimary, fontSize = 13.sp, fontWeight = FontWeight.SemiBold)
                }
            }
        }
    }
}

@Composable
private fun Tabs(selected: Int, onSelect: (Int) -> Unit) {
    Row(modifier = Modifier.padding(horizontal = 22.dp)) {
        TabItem("Lessons", selected == 0) { onSelect(0) }
        Spacer(Modifier.width(28.dp))
        TabItem("Description", selected == 1) { onSelect(1) }
    }
}

@Composable
private fun TabItem(label: String, active: Boolean, onClick: () -> Unit) {
    Column(
        modifier = Modifier.clickable(onClick = onClick),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            label,
            color = if (active) Orange else TabInactive,
            fontSize = 16.sp,
            fontWeight = if (active) FontWeight.SemiBold else FontWeight.Medium
        )
        Spacer(Modifier.height(6.dp))
        Box(
            modifier = Modifier
                .width(if (active) 56.dp else 0.dp)
                .height(2.dp)
                .background(Orange, RoundedCornerShape(2.dp))
        )
    }
}

@Composable
private fun LessonRow(lesson: Lesson) {
    val contentColor = if (lesson.unlocked) TextPrimary else LockedGray
    val timeColor = if (lesson.unlocked) TextSecondary else LockedGray
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 22.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        PlayBadge(playing = lesson.playing, unlocked = lesson.unlocked)
        Spacer(Modifier.width(14.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(lesson.title, color = contentColor, fontSize = 15.sp, fontWeight = FontWeight.Medium)
            Spacer(Modifier.height(3.dp))
            Text(lesson.duration, color = timeColor, fontSize = 12.sp)
        }
        Icon(
            imageVector = Icons.AutoMirrored.Filled.KeyboardArrowRight,
            contentDescription = null,
            tint = if (lesson.unlocked) Orange else LockedGray,
            modifier = Modifier.size(22.dp)
        )
    }
}

@Composable
private fun PlayBadge(playing: Boolean, unlocked: Boolean) {
    val bg = when {
        playing -> Orange
        unlocked -> Color.White
        else -> Color.Transparent
    }
    val border = when {
        playing -> Orange
        unlocked -> Orange
        else -> LockedGray
    }
    val iconTint = when {
        playing -> Color.White
        unlocked -> Orange
        else -> LockedGray
    }
    Box(
        modifier = Modifier
            .size(36.dp)
            .clip(CircleShape)
            .background(bg)
            .then(
                if (!playing) Modifier.border(1.6.dp, border, CircleShape) else Modifier
            ),
        contentAlignment = Alignment.Center
    ) {
        Icon(
            imageVector = Icons.Filled.PlayArrow,
            contentDescription = null,
            tint = iconTint,
            modifier = Modifier.size(20.dp)
        )
    }
}

@Composable
private fun DescriptionBlock() {
    Text(
        text = "Learn React from scratch to production. This course covers components, hooks, routing and a complete front-to-back project workflow with spoken English explanations.",
        color = TextSecondary,
        fontSize = 14.sp,
        lineHeight = 22.sp,
        modifier = Modifier.padding(horizontal = 22.dp, vertical = 12.dp)
    )
}

@Composable
private fun BottomBar(modifier: Modifier = Modifier) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .background(CardWhite)
            .padding(horizontal = 20.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .height(52.dp)
                .width(78.dp)
                .clip(RoundedCornerShape(14.dp))
                .border(1.dp, Color(0xFFE6E8F0), RoundedCornerShape(14.dp))
                .background(CardWhite),
            contentAlignment = Alignment.Center
        ) {
            Text("Free", color = TextPrimary, fontSize = 15.sp, fontWeight = FontWeight.Medium)
        }
        Spacer(Modifier.width(12.dp))
        Box(
            modifier = Modifier
                .height(52.dp)
                .weight(1f)
                .clip(RoundedCornerShape(14.dp))
                .background(Orange),
            contentAlignment = Alignment.Center
        ) {
            Text("Enroll Now", color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
        }
    }
}

@Preview(showBackground = true, widthDp = 390, heightDp = 844)
@Composable
private fun CoursePreview() {
    CourseScreen(onBack = {})
}
