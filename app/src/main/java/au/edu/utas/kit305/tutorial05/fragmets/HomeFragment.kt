package layout

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.viewpager.widget.ViewPager
import au.edu.utas.kit305.tutorial05.databinding.FragmentHomeBinding
import com.example.week05tabs.ui.main.SectionsPagerAdapter
import com.google.android.material.tabs.TabLayout

class HomeFragment : BaseFragment() {
    lateinit var ui: FragmentHomeBinding

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        ui = FragmentHomeBinding.inflate(layoutInflater, container, false)
        val sectionsPagerAdapter = SectionsPagerAdapter(childFragmentManager)
        val viewPager: ViewPager = ui.viewPager
        viewPager.adapter = sectionsPagerAdapter
        val tabs: TabLayout = ui.tabs
        tabs.setupWithViewPager(viewPager)
        return ui.root
    }
}