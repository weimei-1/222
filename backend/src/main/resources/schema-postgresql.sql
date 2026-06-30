-- =============================================
-- 超市订单管理系统 - PostgreSQL 建表脚本
-- 在 Render PostgreSQL 中执行
-- =============================================

DROP TABLE IF EXISTS operation_log;
DROP TABLE IF EXISTS promotion;
DROP TABLE IF EXISTS purchase_order_item;
DROP TABLE IF EXISTS purchase_order;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS member_level_log;
DROP TABLE IF EXISTS member_level;
DROP TABLE IF EXISTS member;
DROP TABLE IF EXISTS order_item;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS sys_user;

CREATE TABLE sys_user (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(200) NOT NULL,
    real_name VARCHAR(50) DEFAULT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'CASHIER',
    phone VARCHAR(20) DEFAULT NULL,
    status INT DEFAULT 1,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_username UNIQUE (username)
);

CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    sort INT DEFAULT 0,
    status INT DEFAULT 1,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    barcode VARCHAR(50) DEFAULT NULL,
    category_id BIGINT DEFAULT NULL,
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    cost_price DECIMAL(10,2) DEFAULT 0.00,
    stock INT DEFAULT 0,
    warning_stock INT DEFAULT 10,
    unit VARCHAR(20) DEFAULT '个',
    image VARCHAR(500) DEFAULT NULL,
    status INT DEFAULT 1,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_barcode UNIQUE (barcode)
);
CREATE INDEX idx_category_id ON product(category_id);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    order_no VARCHAR(30) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    pay_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    cost_amount DECIMAL(10,2) DEFAULT 0.00,
    pay_type VARCHAR(20) DEFAULT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    member_id BIGINT DEFAULT NULL,
    cashier_id BIGINT DEFAULT NULL,
    remark VARCHAR(500) DEFAULT NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_order_no UNIQUE (order_no)
);
CREATE INDEX idx_cashier_id ON orders(cashier_id);
CREATE INDEX idx_create_time ON orders(create_time);
CREATE INDEX idx_status ON orders(status);

CREATE TABLE order_item (
    id SERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    quantity INT NOT NULL DEFAULT 1,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00
);
CREATE INDEX idx_order_id ON order_item(order_id);
CREATE INDEX idx_product_id ON order_item(product_id);

CREATE TABLE member (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    points INT DEFAULT 0,
    total_spent DECIMAL(10,2) DEFAULT 0.00,
    level VARCHAR(20) DEFAULT '普通会员',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_phone UNIQUE (phone)
);

CREATE TABLE member_level (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    min_spent DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    discount_rate DECIMAL(4,2) NOT NULL DEFAULT 1.00,
    points_multiplier DECIMAL(4,2) NOT NULL DEFAULT 1.00,
    sort INT DEFAULT 0,
    status INT DEFAULT 1,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE member_level_log (
    id SERIAL PRIMARY KEY,
    member_id BIGINT NOT NULL,
    old_level VARCHAR(50) NOT NULL,
    new_level VARCHAR(50) NOT NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_member_id ON member_level_log(member_id);

CREATE TABLE supplier (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(50) DEFAULT '',
    phone VARCHAR(20) DEFAULT '',
    address VARCHAR(255) DEFAULT '',
    remark VARCHAR(500) DEFAULT '',
    status INT DEFAULT 1,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE purchase_order (
    id SERIAL PRIMARY KEY,
    order_no VARCHAR(50) NOT NULL,
    supplier_id BIGINT DEFAULT NULL,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    remark VARCHAR(500) DEFAULT '',
    status INT DEFAULT 0,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_order_no ON purchase_order(order_no);
CREATE INDEX idx_supplier_id ON purchase_order(supplier_id);

CREATE TABLE purchase_order_item (
    id SERIAL PRIMARY KEY,
    purchase_order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    product_name VARCHAR(100) DEFAULT '',
    quantity INT NOT NULL DEFAULT 0,
    purchase_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00
);
CREATE INDEX idx_purchase_order_id ON purchase_order_item(purchase_order_id);
CREATE INDEX idx_product_id ON purchase_order_item(product_id);

CREATE TABLE operation_log (
    id SERIAL PRIMARY KEY,
    user_id BIGINT DEFAULT NULL,
    user_name VARCHAR(50) DEFAULT '',
    module VARCHAR(50) NOT NULL,
    action VARCHAR(50) NOT NULL,
    target_id BIGINT DEFAULT NULL,
    detail VARCHAR(500) DEFAULT '',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_module ON operation_log(module);
CREATE INDEX idx_user_id ON operation_log(user_id);
CREATE INDEX idx_create_time ON operation_log(create_time);

CREATE TABLE promotion (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    rule_config TEXT DEFAULT NULL,
    remark VARCHAR(500) DEFAULT '',
    status INT DEFAULT 0,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 初始数据
INSERT INTO sys_user (username, password, real_name, role, phone, status) VALUES
('admin', '0192023a7bbd73250516f069df18b500', '系统管理员', 'ADMIN', '13800000000', 1),
('cashier1', '0192023a7bbd73250516f069df18b500', '收银员张三', 'CASHIER', '13800000001', 1),
('cashier2', '0192023a7bbd73250516f069df18b500', '收银员李四', 'CASHIER', '13800000002', 1);

INSERT INTO category (name, sort, status) VALUES
('饮料', 1, 1),
('零食', 2, 1),
('生鲜', 3, 1),
('日用品', 4, 1),
('粮油调味', 5, 1),
('酒类', 6, 1);

INSERT INTO product (name, barcode, category_id, price, cost_price, stock, warning_stock, unit, status) VALUES
('农夫山泉 550ml', '6901010101001', 1, 2.00, 1.20, 500, 50, '瓶', 1),
('可口可乐 330ml', '6901010101002', 1, 3.00, 1.80, 300, 30, '罐', 1),
('乐事薯片 75g', '6901010101003', 2, 7.00, 4.50, 200, 20, '袋', 1),
('奥利奥饼干 97g', '6901010101004', 2, 9.00, 5.50, 150, 15, '袋', 1),
('鲜鸡蛋 10枚装', '6901010101005', 3, 15.00, 10.00, 80, 10, '盒', 1),
('蒙牛纯牛奶 250ml', '6901010101006', 1, 3.50, 2.20, 400, 40, '盒', 1),
('康师傅方便面 5包', '6901010101007', 2, 12.00, 7.50, 120, 20, '袋', 1),
('海天酱油 500ml', '6901010101008', 5, 8.00, 5.00, 100, 15, '瓶', 1),
('青岛啤酒 330ml', '6901010101009', 6, 5.00, 3.00, 250, 30, '罐', 1),
('维达纸巾 3层', '6901010101010', 4, 25.00, 16.00, 60, 10, '提', 1);

INSERT INTO member (name, phone, points, level) VALUES
('王小明', '13900000001', 500, '金卡会员'),
('赵小红', '13900000002', 200, '普通会员'),
('刘大伟', '13900000003', 1000, '钻石会员');

INSERT INTO member_level (name, min_spent, discount_rate, points_multiplier, sort, status) VALUES
('普通会员', 0, 1.00, 1.0, 1, 1),
('银卡会员', 500, 0.95, 1.2, 2, 1),
('金卡会员', 2000, 0.90, 1.5, 3, 1),
('钻石会员', 5000, 0.85, 2.0, 4, 1);
