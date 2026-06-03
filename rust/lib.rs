#![no_std]
#![no_main]

use core::panic::PanicInfo;
use core::str::from_utf8_unchecked;

#[no_mangle]
pub extern "C" fn rust_init() {
    // инициализация
}

#[no_mangle]
pub extern "C" fn rust_calc(expr: *const u8) -> i32 {
    let expr_str = unsafe {
        let mut len = 0;
        while *expr.add(len) != 0 { len += 1; }
        from_utf8_unchecked(core::slice::from_raw_parts(expr, len))
    };
    
    if expr_str.contains('+') {
        let parts: Vec<&str> = expr_str.split('+').collect();
        if parts.len() == 2 {
            let a: i32 = parts[0].trim().parse().unwrap_or(0);
            let b: i32 = parts[1].trim().parse().unwrap_or(0);
            return a + b;
        }
    }
    
    if expr_str.contains('*') {
        let parts: Vec<&str> = expr_str.split('*').collect();
        if parts.len() == 2 {
            let a: i32 = parts[0].trim().parse().unwrap_or(0);
            let b: i32 = parts[1].trim().parse().unwrap_or(0);
            return a * b;
        }
    }
    
    0
}

#[no_mangle]
pub extern "C" fn rust_strlen(s: *const u8) -> usize {
    let mut len = 0;
    unsafe {
        while *s.add(len) != 0 {
            len += 1;
        }
    }
    len
}

#[no_mangle]
pub extern "C" fn rust_sqrt(x: i32) -> i32 {
    let mut guess = x as f64;
    for _ in 0..10 {
        guess = (guess + (x as f64) / guess) * 0.5;
    }
    guess as i32
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
