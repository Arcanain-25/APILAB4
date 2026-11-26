package com.edulearn.app.data

data class LearningPlanItem(
    val title: String,
    val done: Int,
    val total: Int
)

data class Lesson(
    val title: String,
    val duration: String,
    val unlocked: Boolean,
    val playing: Boolean = false
)

val learningPlan = listOf(
    LearningPlanItem("Packaging Design", 40, 48),
    LearningPlanItem("Product Design", 6, 24)
)

val courseLessons = listOf(
    Lesson("Introduction to React", "04:28 min", unlocked = true, playing = true),
    Lesson("Understanding React", "06:12 min", unlocked = true),
    Lesson("Create first React project", "43:58 min", unlocked = true),
    Lesson("Build React", "26:18 min", unlocked = false)
)
