open Ctypes
open Foreign

(** xcb_connection_t* *)
type connection = unit ptr
let connection : connection typ = ptr void

(** xcb_setup_t* *)
type setup = unit ptr
let setup : setup typ = ptr void

(** xcb_window_t *)
type window = Unsigned.uint32
let window : window typ = uint32_t

(** xcb_colormap_t *)
type colormap = Unsigned.uint32
let colormap : colormap typ = uint32_t

(** xcb_visualid_t *)
type visualid = Unsigned.uint32
let visualid : visualid typ = uint32_t

(** xcb_keycode_t *)
type keycode = Unsigned.uint8
let keycode : keycode typ = uint8_t

(** xcb_void_cookie_t structure *)
type void_cookie
let void_cookie : void_cookie structure typ = structure "void_cookie"
let sequence = field void_cookie "sequence" uint
let () = seal void_cookie

(** xcb_screen_t structure *)
module Screen = struct
    type screen
    let screen : screen structure typ = structure "xcb_screen_t"
    let root                  = field screen "root"                  window
    let default_colormap      = field screen "default_colormap"      colormap
    let white_pixel           = field screen "white_pixel"           uint32_t
    let black_pixel           = field screen "black_pixel"           uint32_t
    let current_input_masks   = field screen "current_input_masks"   uint32_t
    let width_in_pixels       = field screen "width_in_pixels"       uint16_t
    let height_in_pixels      = field screen "height_in_pixels"      uint16_t
    let width_in_millimeters  = field screen "width_in_millimeters"  uint16_t
    let height_in_millimeters = field screen "height_in_millimeters" uint16_t
    let min_installed_maps    = field screen "min_installed_maps"    uint16_t
    let max_installed_maps    = field screen "max_installed_maps"    uint16_t
    let root_visual           = field screen "root_visual"           visualid
    let backing_stores        = field screen "backing_stores"        uint8_t
    let save_unders           = field screen "save_unders"           uint8_t
    let root_depth            = field screen "root_depth"            uint8_t
    let allowed_depths_len    = field screen "allowed_depths_len"    uint8_t
    let () = seal screen
end

(** xcb_screen_iterator_t structure *)
module Screen_iterator = struct
    type screen_iterator
    let screen_iterator : screen_iterator structure typ = structure "xcb_screen_iterator_t"
    let data  = field screen_iterator "data"  (ptr Screen.screen)
    let rem   = field screen_iterator "rem"   int
    let index = field screen_iterator "index" int
    let () = seal screen_iterator
end

module Mod_mask = struct
    let shift   = 1
    let lock    = 2
    let control = 4
    let mod_1   = 8
    let mod_2   = 16
    let mod_3   = 32
    let mod_4   = 64
    let mod_5   = 128
    let any     = 32768
end

(** xcb_connect(const char* displayname, int* screenp) *)
let connect =
    foreign "xcb_connect" (string  (* display name *)
                       @-> ptr int (* preferred screen number pointer *)
                       @-> returning connection)

(** xcb_get_setup(xcb_connection_t *c) *)
let get_setup =
    foreign "xcb_get_setup" (connection @-> returning setup)

let setup_roots_iterator =
    foreign "xcb_setup_roots_iterator" (setup @-> returning Screen_iterator.screen_iterator)

let grab_key =
    foreign "xcb_grab_key" (connection
                        @-> uint8_t  (* owner events *)
                        @-> window   (* window to grab *)
                        @-> uint16_t (* modifiers *)
                        @-> keycode  (* keycode of key to grab *)
                        @-> uint8_t  (* pointer mode *)
                        @-> uint8_t  (* keyboard mode *)
                        @-> returning void_cookie)
