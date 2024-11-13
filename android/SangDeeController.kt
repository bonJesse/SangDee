import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

class SangDeeController : AppCompatActivity() {
    
    private lateinit var previewArea: View
    private lateinit var colorCardsRecyclerView: RecyclerView
    private lateinit var quickBrightnessSlider: SeekBar
    private lateinit var drawerLayout: DrawerLayout
    private lateinit var sideMenuView: NavigationView
    
    private val presetManager = PresetManager()
    private val lightController = LightController()
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sangdee)
        
        setupUI()
        setupListeners()
    }
    
    private fun setupUI() {
        // Setup toolbar
        setSupportActionBar(findViewById(R.id.toolbar))
        supportActionBar?.apply {
            setDisplayHomeAsUpEnabled(true)
            setHomeAsUpIndicator(R.drawable.ic_menu)
        }
        
        // Setup preview area
        previewArea = findViewById(R.id.preview_area)
        
        // Setup color cards
        colorCardsRecyclerView = findViewById(R.id.color_cards_recycler)
        colorCardsRecyclerView.apply {
            layoutManager = LinearLayoutManager(this@SangDeeController, 
                LinearLayoutManager.HORIZONTAL, false)
            adapter = ColorCardAdapter(presetManager.presets) { preset ->
                lightController.applyPreset(preset)
                previewArea.setBackgroundColor(preset.color)
            }
        }
        
        // Setup brightness slider
        quickBrightnessSlider = findViewById(R.id.quick_brightness_slider)
        quickBrightnessSlider.max = 100
        quickBrightnessSlider.progress = 50
        
        // Setup side menu
        drawerLayout = findViewById(R.id.drawer_layout)
        sideMenuView = findViewById(R.id.side_menu_view)
    }
    
    private fun setupListeners() {
        quickBrightnessSlider.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
            override fun onProgressChanged(seekBar: SeekBar, progress: Int, fromUser: Boolean) {
                lightController.setBrightness(progress / 100f)
            }
            
            override fun onStartTrackingTouch(seekBar: SeekBar) {}
            override fun onStopTrackingTouch(seekBar: SeekBar) {}
        })
    }
    
    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            android.R.id.home -> {
                drawerLayout.openDrawer(GravityCompat.START)
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }
} 