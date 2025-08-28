-- ===================================================
-- CREATE TABLE Examples (Oracle)
-- ===================================================

-- 1. 기본 테이블 생성
CREATE TABLE emp_basic (
    emp_id      NUMBER(6),
    emp_name    VARCHAR2(50),
    hire_date   DATE,
    salary      NUMBER(10,2)
);

-- 2. NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGN KEY 제약조건
CREATE TABLE emp_constraints (
    emp_id      NUMBER(6)       CONSTRAINT pk_emp PRIMARY KEY,
    emp_name    VARCHAR2(50)    CONSTRAINT nn_emp_name NOT NULL,
    email       VARCHAR2(100)   CONSTRAINT uq_emp_email UNIQUE,
    salary      NUMBER(10,2)    CONSTRAINT ck_emp_salary CHECK (salary > 0),
    dept_id     NUMBER(4),
    CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id)
        REFERENCES dept(dept_id)
);

-- 3. DEFAULT 값 지정
CREATE TABLE emp_defaults (
    emp_id      NUMBER(6) PRIMARY KEY,
    emp_name    VARCHAR2(50) NOT NULL,
    hire_date   DATE DEFAULT SYSDATE,
    status      VARCHAR2(10) DEFAULT 'ACTIVE'
);

-- 4. TEMPORARY 테이블 (세션별/트랜잭션별 유지)
CREATE GLOBAL TEMPORARY TABLE temp_orders (
    order_id    NUMBER,
    order_date  DATE,
    amount      NUMBER
) ON COMMIT PRESERVE ROWS;
-- 또는: ON COMMIT DELETE ROWS;

-- 5. 테이블스페이스 지정
CREATE TABLE emp_ts (
    emp_id   NUMBER,
    emp_name VARCHAR2(50)
) TABLESPACE users;

-- 6. STORAGE 옵션 지정 (구버전에서 주로 사용)
CREATE TABLE emp_storage (
    emp_id   NUMBER,
    emp_name VARCHAR2(50)
)
TABLESPACE users
STORAGE (
    INITIAL 1M
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
);

-- 7. PARTITIONED TABLE
CREATE TABLE sales_partition (
    sale_id     NUMBER,
    sale_date   DATE,
    amount      NUMBER
)
PARTITION BY RANGE (sale_date) (
    PARTITION sales_q1 VALUES LESS THAN (TO_DATE('2024-04-01','YYYY-MM-DD')),
    PARTITION sales_q2 VALUES LESS THAN (TO_DATE('2024-07-01','YYYY-MM-DD')),
    PARTITION sales_q3 VALUES LESS THAN (TO_DATE('2024-10-01','YYYY-MM-DD')),
    PARTITION sales_q4 VALUES LESS THAN (MAXVALUE)
);

-- 8. SUBPARTITIONED TABLE (Range + Hash)
CREATE TABLE sales_subpart (
    sale_id     NUMBER,
    sale_date   DATE,
    region_id   NUMBER,
    amount      NUMBER
)
PARTITION BY RANGE (sale_date)
SUBPARTITION BY HASH (region_id)
SUBPARTITIONS 4
(
    PARTITION p_2024q1 VALUES LESS THAN (TO_DATE('2024-04-01','YYYY-MM-DD')),
    PARTITION p_2024q2 VALUES LESS THAN (TO_DATE('2024-07-01','YYYY-MM-DD')),
    PARTITION p_max VALUES LESS THAN (MAXVALUE)
);

-- 9. CREATE TABLE AS SELECT (CTAS)
CREATE TABLE emp_copy AS
SELECT * FROM employees WHERE 1=0; -- 구조만 복사 (데이터 X)

-- 10. EXTERNAL TABLE (OS 파일을 테이블처럼 읽기)
CREATE TABLE ext_emp (
    emp_id   NUMBER,
    emp_name VARCHAR2(50),
    salary   NUMBER
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_dir
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ','
        ( emp_id, emp_name, salary )
    )
    LOCATION ('emp_data.csv')
)
REJECT LIMIT UNLIMITED;

-- ===================================================
-- END OF FILE
-- ===================================================
