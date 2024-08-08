package com.example.week05tabs.ui.main

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter
import layout.StudentListFragment
import layout.TutorialListFragment


class SectionsPagerAdapter(fm: FragmentManager)
    : FragmentPagerAdapter(fm) {

    private val TAB_TITLES = arrayOf(
        "Tutorials",
        "Students"
    )
    override fun getItem(position: Int): Fragment {
        // getItem is called to instantiate the fragment for the given page.
        return when (position)
        {
            0 -> TutorialListFragment()
            1 -> StudentListFragment()
            else -> TutorialListFragment()
        }
    }

    override fun getPageTitle(position: Int): CharSequence? {
        return TAB_TITLES[position]
    }

    override fun getCount(): Int {
        // Show 2 total pages.
        return 2
    }
}