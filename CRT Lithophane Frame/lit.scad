/* TVA Style CRT Lithophane Frame 
  For Bambu A1 mini (0.4mm nozzle)
  Dimensions tailored for 108x144x2.5mm Lithophane
*/

// --- 參數設定 ---
$fn = 60; // 圓滑度

// 浮雕畫尺寸
litho_w = 108;
litho_h = 144;
litho_t = 2.5;

// 外框參數
wall_thick = 9; // 外框厚實感 (CRT風格)
corner_radius = 8; // 邊角圓潤程度
bezel_depth = 15; // 前框深度
back_depth = 30; // 後蓋深度 (容納LED)
bevel_angle = 3; // 正面向內的斜角深度
tolerance = 0.25; // PETG 卡扣公差

// LED 燈板參數 (Bambu CMYK LED Board)
led_w = 122;
led_h = 158;
usb_w = 18;
usb_h = 16;
usb_y = -73; // USB 開孔 Y 軸位置

// 字體設定 (請確保電腦有安裝對應字體)
font_typewriter = "Courier New:style=Bold";
font_chinese = "Microsoft JhengHei:style=Bold"; // 或 "Noto Sans CJK TC"

// --- 零件選擇切換 ---
// 將 1 改為 0 即可隱藏該零件以單獨匯出 STL
show_front = 1;
show_back = 1;

// ==========================================
// 計算外框總尺寸
outer_w = litho_w + (wall_thick * 2);
outer_h = litho_h + (wall_thick * 2);

if (show_front) {
  FrontBezel();
}

if (show_back) {
  // 將後蓋移到旁邊方便預覽與列印
  translate([outer_w + 10, 0, 0]) BackCover();
}

// ==========================================
// 模組：帶圓角的方形 (2D)
module RoundedRect(w, h, r) {
  translate([-w / 2 + r, -h / 2 + r])
    minkowski() {
      square([w - 2 * r, h - 2 * r]);
      circle(r=r);
    }
}

// 模組：帶圓角的長方體 (3D)
module RoundedBox(w, h, d, r) {
  linear_extrude(d) RoundedRect(w, h, r);
}

// 模組：3D 雕刻文字
module EngravedText(t, font_name, text_size, ext_depth, h_align, v_align) {
  linear_extrude(ext_depth)
    text(t, font=font_name, size=text_size, halign=h_align, valign=v_align);
}

// 模組：前框 (CRT 螢幕造型)
module FrontBezel() {
  difference() {
    // 1. 主體：具有向內斜角的 CRT 外框
    hull() {
      // 底部較寬
      RoundedBox(outer_w, outer_h, 0.1, corner_radius);
      // 頂部較窄形成斜角
      translate([0, 0, bezel_depth])
        RoundedBox(outer_w - bevel_angle * 2, outer_h - bevel_angle * 2, 0.1, corner_radius);
    }

    // 2. 挖空：給浮雕畫的視窗 (比浮雕畫面稍微小一點以卡住邊緣)
    translate([0, 0, -1])
      RoundedBox(litho_w - 4, litho_h - 4, bezel_depth + 2, corner_radius / 2);

    // 3. 挖空：內部放置浮雕畫的凹槽 (Lithophane Slot)
    translate([0, 0, bezel_depth - litho_t])
      RoundedBox(litho_w + 0.5, litho_h + 0.5, litho_t + 1, corner_radius / 2);

    // 4. 文字雕刻 (正面)
    // 頂部諺語
    translate([0, outer_h / 2 - wall_thick + 1, bezel_depth - 0.6]) // 深度刻 0.6mm
      EngravedText("Forever is composed of nows.", font_typewriter, 4.5, 2, "center", "bottom");

    // 底部作者
    translate([0, -outer_h / 2 + wall_thick - 1, bezel_depth - 0.6])
      EngravedText("- Emily Dickinson", font_typewriter, 4, 2, "center", "top");
  }

  // 6. 卡扣唇 (向後延伸的接合部)
  translate([0, 0, -5])
    difference() {
      RoundedBox(outer_w - wall_thick, outer_h - wall_thick, 5, corner_radius - 1);
      translate([0, 0, -1])
        RoundedBox(outer_w - wall_thick * 2, outer_h - wall_thick * 2, 7, corner_radius - 2);
    }
}

// 模組：後蓋 (放置 LED 與走線孔)
module BackCover() {
  difference() {
    // 1. 後蓋主體
    RoundedBox(outer_w, outer_h, back_depth, corner_radius);

    // 2. 內部挖空 (擴大以容納 Bambu CMYK LED Board 120x156mm)
    translate([0, 0, 2]) // 保留 2mm 底板厚度
      // 挖空至卡扣下方，不破壞卡扣結構
      RoundedBox(led_w, led_h, back_depth - 5, corner_radius - 1);

    // 為了讓前框卡扣能正常咬合，保留頂部 (z = 25~30) 的支撐內壁
    translate([0, 0, back_depth - 5.01])
      RoundedBox(outer_w - wall_thick * 1.5, outer_h - wall_thick * 1.5, 6, corner_radius - 1);

    // 3. 卡扣凹槽 (容納前框的卡扣唇，加上 tolerance 公差)
    translate([0, 0, back_depth - 5])
      linear_extrude(6)
        difference() {
          RoundedRect(outer_w - wall_thick + tolerance, outer_h - wall_thick + tolerance, corner_radius - 0.8);
          RoundedRect(outer_w - wall_thick * 2 - tolerance, outer_h - wall_thick * 2 - tolerance, corner_radius - 2.2);
        }

    // 4. USB 直插孔位 (修正：配合垂直向後突出的 Type-C 接口)
    // 燈板高 156，底部邊界在 Y=-78。
    // 開一個 18x16mm 的孔在背板上 (Z=0~2)，讓 Type-C 接口及線材頭可以直接穿出
    translate([0, usb_y, -1])
      // 確保完全貫穿 2mm 的背板
      RoundedBox(usb_w, usb_h, 10, 3);

    // 5. 文字雕刻 (側邊 - 移至後蓋右側)
    // 將 Z 軸高度設定在後蓋的中心 (back_depth/2)
    translate([outer_w / 2 - 0.6, 0, back_depth / 2])
      rotate([90, 0, 90]) // 旋轉到右側面
        EngravedText("2026 復興高中同學ting生日聚餐", font_chinese, 4, 2, "center", "center");
  }
}
