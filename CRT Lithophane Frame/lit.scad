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

// 模組：前框 (CRT 螢幕造型)

module FrontBezel() {

  difference() {

    // 1. 主體：具有向內斜角的 CRT 外框

    hull() {

      // 底部較寬

      linear_extrude(0.1) RoundedRect(outer_w, outer_h, corner_radius);

      // 頂部較窄形成斜角

      translate([0, 0, bezel_depth])

        linear_extrude(0.1) RoundedRect(outer_w - bevel_angle * 2, outer_h - bevel_angle * 2, corner_radius);
    }

    // 2. 挖空：給浮雕畫的視窗 (比浮雕畫面稍微小一點以卡住邊緣)

    translate([0, 0, -1])

      linear_extrude(bezel_depth + 2)

        RoundedRect(litho_w - 4, litho_h - 4, corner_radius / 2);

    // 3. 挖空：內部放置浮雕畫的凹槽 (Lithophane Slot)

    translate([0, 0, bezel_depth - litho_t])

      linear_extrude(litho_t + 1)

        RoundedRect(litho_w + 0.5, litho_h + 0.5, corner_radius / 2);

    // 4. 文字雕刻 (正面)

    // 頂部諺語

    translate([0, outer_h / 2 - wall_thick + 1, bezel_depth - 0.6]) // 深度刻 0.6mm

      linear_extrude(2)

        text("Forever is composed of nows.", font=font_typewriter, size=4.5, halign="center", valign="botton");

    // 底部作者

    translate([0, -outer_h / 2 + wall_thick - 1, bezel_depth - 0.6])

      linear_extrude(2)

        text("- Emily Dickinson", font=font_typewriter, size=4, halign="center", valign="top");
  }

  // 6. 卡扣唇 (向後延伸的接合部)

  translate([0, 0, -5])

    difference() {

      linear_extrude(5) RoundedRect(outer_w - wall_thick, outer_h - wall_thick, corner_radius - 1);

      translate([0, 0, -1])

        linear_extrude(7) RoundedRect(outer_w - wall_thick * 2, outer_h - wall_thick * 2, corner_radius - 2);
    }
}

// 模組：後蓋 (放置 LED 與走線孔)

module BackCover() {

  difference() {

    // 1. 後蓋主體

    linear_extrude(back_depth) RoundedRect(outer_w, outer_h, corner_radius);

    // 2. 內部挖空

    translate([0, 0, 2]) // 保留 2mm 底板厚度

      linear_extrude(back_depth)

        RoundedRect(outer_w - wall_thick * 1.5, outer_h - wall_thick * 1.5, corner_radius - 1);

    // 3. 卡扣凹槽 (容納前框的卡扣唇，加上 tolerance 公差)

    translate([0, 0, back_depth - 5])

      linear_extrude(6)

        difference() {

          RoundedRect(outer_w - wall_thick + tolerance, outer_h - wall_thick + tolerance, corner_radius - 0.8);

          RoundedRect(outer_w - wall_thick * 2 - tolerance, outer_h - wall_thick * 2 - tolerance, corner_radius - 2.2);
        }

    // 4. USB 走線孔 (加大孔徑，保證不被封死)
    // [修正] 將起點往內部移動 (+wall_thick + 5)，並加長擠出距離，確保由內向外完全貫穿牆壁
    translate([0, -outer_h / 2 + wall_thick + 5, 10])
      rotate([90, 0, 0])
        linear_extrude(wall_thick + 15)
          RoundedRect(16, 10, 2);

    // 5. 文字雕刻 (側邊 - 移至後蓋右側)
    // 將 Z 軸高度設定在後蓋的中心 (back_depth/2)
    translate([outer_w / 2 - 0.6, 0, back_depth / 2])
      rotate([90, 0, 90]) // 旋轉到右側面
        linear_extrude(2)
          text("2026 復興高中同學ting生日聚餐", font=font_chinese, size=4, halign="center", valign="center");
  }
}
