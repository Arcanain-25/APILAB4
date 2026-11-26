package com.edulearn.app.ui.home

import android.app.Activity
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.view.WindowInsetsControllerCompat
import com.edulearn.app.R
import com.edulearn.app.data.LearningPlanItem
import com.edulearn.app.data.learningPlan
import com.edulearn.app.ui.theme.BrandBlue
import com.edulearn.app.ui.theme.CardWhite
import com.edulearn.app.ui.theme.ChecklistCardBg
import com.edulearn.app.ui.theme.LearnCardBg
import com.edulearn.app.ui.theme.MeetupBg
import com.edulearn.app.ui.theme.MeetupTitle
import com.edulearn.app.ui.theme.Orange
import com.edulearn.app.ui.theme.OrangeDeep
import com.edulearn.app.ui.theme.PageBg
import com.edulearn.app.ui.theme.ProgressTrack
import com.edulearn.app.ui.theme.RingBlue
import com.edulearn.app.ui.theme.RingTrack
import com.edulearn.app.ui.theme.TextMuted
import com.edulearn.app.ui.theme.TextPrimary
import com.edulearn.app.ui.theme.TextSecondary

@Composable
fun HomeScreen(onOpenCourse: () -> Unit) {
    val view = LocalView.current
    SideEffect {
        val window = (view.context as Activity).window
        WindowInsetsControllerCompat(window, view).isAppearanceLightStatusBars = false
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(PageBg)
            .verticalScroll(rememberScrollState())
    ) {
        HeaderSection(onOpenCourse = onOpenCourse)
        Spacer(Modifier.height(18.dp))
        PromoCarousel(onOpenCourse = onOpenCourse)
        Spacer(Modifier.height(22.dp))
        LearningPlanSection()
        Spacer(Modifier.height(18.dp))
        MeetupBanner()
        Spacer(Modifier.height(28.dp))
    }
}

@Composable
private fun HeaderSection(onOpenCourse: () -> Unit) {
    Box(modifier = Modifier.fillMaxWidth()) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(268.dp)
                .background(BrandBlue)
        )
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .statusBarsPadding()
                .padding(horizontal = 22.dp)
        ) {
            Spacer(Modifier.height(10.dp))
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text(
                        text = "Hi, Kristin",
                        color = Color.White,
                        fontSize = 28.sp,
                        fontWeight = FontWeight.Bold,
                        letterSpacing = (-0.3).sp
                    )
                    Spacer(Modifier.height(4.dp))
                    Text(
                        text = "Let's start learning",
                        color = Color.White.copy(alpha = 0.72f),
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Normal
                    )
                }
                Image(
                    painter = painterResource(R.drawable.avatar_kristin),
                    contentDescription = "Profile",
                    contentScale = ContentScale.Crop,
                    modifier = Modifier
                        .size(48.dp)
                        .clip(CircleShape)
                        .background(Color.White.copy(alpha = 0.2f))
                )
            }
            Spacer(Modifier.height(22.dp))
            LearnedTodayCard(onOpenCourse = onOpenCourse)
        }
    }
}

@Composable
private fun LearnedTodayCard(onOpenCourse: () -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .offset(y = 8.dp)
            .shadow(18.dp, RoundedCornerShape(22.dp), ambientColor = Color(0x33000000))
            .clip(RoundedCornerShape(22.dp))
            .background(CardWhite)
            .clickable(onClick = onOpenCourse)
            .padding(horizontal = 18.dp, vertical = 16.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text("Learned today", color = TextSecondary, fontSize = 13.sp)
            Text(
                "My courses",
                color = BrandBlue,
                fontSize = 13.sp,
                fontWeight = FontWeight.Medium
            )
        }
        Spacer(Modifier.height(8.dp))
        Text(
            buildAnnotatedString {
                withStyle(
                    SpanStyle(
                        color = TextPrimary,
                        fontWeight = FontWeight.Bold,
                        fontSize = 26.sp
                    )
                ) { append("46min") }
                withStyle(
                    SpanStyle(
                        color = TextMuted,
                        fontWeight = FontWeight.Medium,
                        fontSize = 14.sp
                    )
                ) { append(" / 60min") }
            }
        )
        Spacer(Modifier.height(12.dp))
        Canvas(
            modifier = Modifier
                .fillMaxWidth()
                .height(8.dp)
        ) {
            val radius = size.height / 2
            drawRoundRect(
                color = ProgressTrack,
                cornerRadius = CornerRadius(radius, radius)
            )
            drawRoundRect(
                brush = Brush.horizontalGradient(listOf(Orange, OrangeDeep)),
                size = Size(size.width * 0.76f, size.height),
                cornerRadius = CornerRadius(radius, radius)
            )
        }
    }
}

@Composable
private fun PromoCarousel(onOpenCourse: () -> Unit) {
    Row(
        modifier = Modifier
            .horizontalScroll(rememberScrollState())
            .padding(start = 22.dp, end = 10.dp),
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Box(
            modifier = Modifier
                .width(268.dp)
                .height(168.dp)
                .clip(RoundedCornerShape(22.dp))
                .background(LearnCardBg)
                .clickable(onClick = onOpenCourse)
        ) {
            Image(
                painter = painterResource(R.drawable.lab2),
                contentDescription = null,
                contentScale = ContentScale.Crop,
                modifier = Modifier
                    .align(Alignment.CenterEnd)
                    .fillMaxHeight()
                    .width(168.dp)
                    .offset(x = 18.dp)
            )
            Column(
                modifier = Modifier
                    .align(Alignment.CenterStart)
                    .padding(start = 16.dp, end = 110.dp, top = 16.dp, bottom = 16.dp)
            ) {
                Text(
                    text = "What do you want to learn today?",
                    color = TextPrimary,
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    lineHeight = 21.sp
                )
                Spacer(Modifier.height(16.dp))
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(8.dp))
                        .background(Orange)
                        .clickable(onClick = onOpenCourse)
                        .padding(horizontal = 14.dp, vertical = 8.dp)
                ) {
                    Text(
                        "Get Started",
                        color = Color.White,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                }
            }
        }

        Box(
            modifier = Modifier
                .width(118.dp)
                .height(168.dp)
                .clip(RoundedCornerShape(22.dp))
                .background(ChecklistCardBg)
                .clickable(onClick = onOpenCourse)
        ) {
            Image(
                painter = painterResource(R.drawable.ill_checklist),
                contentDescription = null,
                contentScale = ContentScale.Crop,
                modifier = Modifier.fillMaxSize()
            )
        }
    }
}

@Composable
private fun LearningPlanSection() {
    Column(modifier = Modifier.padding(horizontal = 22.dp)) {
        Text(
            "Learning Plan",
            color = TextPrimary,
            fontSize = 18.sp,
            fontWeight = FontWeight.Bold
        )
        Spacer(Modifier.height(12.dp))
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .shadow(10.dp, RoundedCornerShape(18.dp), ambientColor = Color(0x14000000))
                .clip(RoundedCornerShape(18.dp))
                .background(CardWhite)
                .padding(horizontal = 16.dp, vertical = 8.dp)
        ) {
            learningPlan.forEach { item ->
                LearningPlanRow(item)
            }
        }
    }
}

@Composable
private fun LearningPlanRow(item: LearningPlanItem) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        RingProgress(progress = item.done / item.total.toFloat())
        Spacer(Modifier.width(12.dp))
        Text(
            item.title,
            color = TextPrimary,
            fontSize = 14.sp,
            fontWeight = FontWeight.Medium,
            modifier = Modifier.weight(1f)
        )
        Text(
            buildAnnotatedString {
                withStyle(SpanStyle(color = TextPrimary, fontWeight = FontWeight.SemiBold, fontSize = 13.sp)) {
                    append("${item.done}")
                }
                withStyle(SpanStyle(color = TextMuted, fontSize = 13.sp)) {
                    append("/${item.total}")
                }
            }
        )
    }
}

@Composable
private fun RingProgress(progress: Float) {
    Canvas(modifier = Modifier.size(22.dp)) {
        val stroke = Stroke(width = 3.2.dp.toPx(), cap = StrokeCap.Round)
        drawCircle(color = RingTrack, style = stroke)
        drawArc(
            color = RingBlue,
            startAngle = -90f,
            sweepAngle = 360f * progress.coerceIn(0f, 1f),
            useCenter = false,
            style = stroke
        )
    }
}

@Composable
private fun MeetupBanner() {
    Box(
        modifier = Modifier
            .padding(horizontal = 22.dp)
            .fillMaxWidth()
            .height(104.dp)
            .clip(RoundedCornerShape(18.dp))
            .background(MeetupBg)
    ) {
        Image(
            painter = painterResource(R.drawable.ill_meetup),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier
                .align(Alignment.CenterEnd)
                .fillMaxHeight()
                .width(150.dp)
                .offset(x = 8.dp)
        )
        Column(
            modifier = Modifier
                .align(Alignment.CenterStart)
                .padding(start = 20.dp, end = 140.dp)
        ) {
            Text(
                "Meetup",
                color = MeetupTitle,
                fontSize = 22.sp,
                fontWeight = FontWeight.Bold
            )
            Spacer(Modifier.height(4.dp))
            Text(
                "Off-line exchange of learning experience",
                color = MeetupTitle.copy(alpha = 0.72f),
                fontSize = 11.sp,
                lineHeight = 15.sp
            )
        }
    }
}

@Preview(showBackground = true, widthDp = 390, heightDp = 844)
@Composable
private fun HomePreview() {
    HomeScreen(onOpenCourse = {})
}
