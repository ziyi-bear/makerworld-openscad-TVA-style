# TVA CRT Lithophane Frame

本專案對模型進行了以下改良設計：

* **內部空間擴容**：把後蓋內部的 LED 容納區塊擴大到 122 x 158 mm，讓 Bambu 燈板可以剛剛好放進去，同時保留了原本上方的卡扣厚度，確保前後蓋依然能完美扣合。
* **孔位精準對齊**：把挖孔位置定在 Y = -73，這剛好覆蓋了從 Y=-65 到 Y=-81 的範圍，完美包覆 Bambu 燈板邊緣的 Type-C 接口。
* **孔徑預留公差**：孔的大小設定為 18 x 16 mm，這個尺寸不但能讓 Type-C 接口本身順利穿過，即使你用的是頭比較粗的 Type-C 充電線，也不會被背板卡住插不深。

## 額外採購硬體零件

* **Bambu CMYK LED Backlight Board** 作為 LED 背板

### 規格資訊

| 規格項目 | 參數 / 說明 |
| --- | --- |
| **尺寸 (Size)** | 156 mm x 120 mm <br> 144 mm x 108 mm (發光區域) |
| **光源類型 (Light Type)** | LED |
| **供電方式 (Power Source)** | 有線供電 (Corded Electric) |
| **電源接口 (Power Port)** | USB-C |
| **燈光顏色 (Light Color)** | 白色 (White) |
| **燈珠數量 (Bead Count)** | 99 顆 |
| **功率 (Wattage)** | 5W |
| **運作溫度 (Temperature)** | 70 ℃ |
| **重量 (Weight)** | 59g |

## 可變更參數

你可以透過修改 `lit.scad` 檔案開頭的變數來客製化你的相框，以下為主要的參數說明：

### 🖼️ 浮雕畫尺寸 (Lithophane Dimensions)
* `litho_w = 108;`：浮雕畫寬度 (mm)
* `litho_h = 144;`：浮雕畫高度 (mm)
* `litho_t = 2.5;`：浮雕畫厚度 (mm)

### 📺 外框造型 (Frame Parameters)
* `wall_thick = 9;`：外框厚實感 (控制 CRT 風格的邊框寬度)
* `corner_radius = 8;`：邊角的圓潤程度
* `bezel_depth = 15;`：前框深度
* `back_depth = 30;`：後蓋深度 (用來容納 LED 燈板的空間)
* `bevel_angle = 3;`：正面向內的斜角深度
* `tolerance = 0.25;`：PETG 卡扣公差 (若列印後卡扣太緊或太鬆，可微調此數值)

### 🔠 刻字與字體 (Text & Fonts)
* `font_typewriter` / `font_chinese`：設定雕刻使用的字型，請確保您的系統已安裝對應的字體。
* **客製化文字**：可以在程式碼中搜尋 `text(`，將「Forever is composed of nows.」或側邊的紀念文字替換為您專屬的訊息。

### ⚙️ 匯出控制 (Export Control)
* `show_front` / `show_back`：設定為 `1` 顯示，設定為 `0` 隱藏。這在需要單獨匯出前框或後蓋的 STL 檔案進行列印時非常方便。