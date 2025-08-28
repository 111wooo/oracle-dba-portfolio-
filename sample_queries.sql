-- =============================================
-- Oracle SQL Sample Queries with Explanations
-- =============================================

-- ==============================
-- 1. 기본 SELECT
-- ==============================

-- 모든 데이터 조회
SELECT * FROM employees;

-- 특정 컬럼만 조회
SELECT emp_name, salary FROM employees;

-- 조건 조회
SELECT emp_name, salary FROM employees WHERE salary > 5000;


-- ==============================
-- 2. 정렬 & 제한
-- ==============================

-- 급여 높은 순으로 정렬
SELECT emp_name, salary FROM employees ORDER BY salary DESC;

-- 상위 10명만 출력 (Oracle 12c 이상)
SELECT emp_name, salary FROM employees ORDER BY salary DESC FETCH FIRST 10 ROWS ONLY;


-- ==============================
-- 3. 집계 & 그룹화
-- ==============================

-- 부서별 평균 급여
SELECT dept_id, AVG(salary) FROM employees GROUP BY dept_id;

-- HAVING (집계 조건)
SELECT dept_id, COUNT(*) 
FROM employees 
GROUP BY dept_id 
HAVING COUNT(*) > 5;


-- ==============================
-- 4. JOIN
-- ==============================

-- 내부 조인
SELECT e.emp_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- 외부 조인
SELECT e.emp_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;


-- ==============================
-- 5. 서브쿼리
-- ==============================

-- 부서 평균보다 급여 높은 직원
SELECT emp_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);


-- ==============================
-- 6. DML (데이터 조작)
-- ==============================

-- INSERT
INSERT INTO employees (emp_id, emp_name, salary, dept_id)
VALUES (1001, 'Alice', 5000, 10);

-- UPDATE
UPDATE employees SET salary = salary * 1.1 WHERE dept_id = 10;

-- DELETE
DELETE FROM employees WHERE emp_id = 1001;


-- ==============================
-- 7. 기타 (실무/면접 단골)
-- ==============================

-- ROWNUM 사용 (구버전 페이징)
SELECT * FROM (
  SELECT emp_name, salary FROM employees ORDER BY salary DESC
) WHERE ROWNUM <= 5;

-- CASE 표현식
SELECT emp_name,
       CASE WHEN salary >= 10000 THEN 'HIGH'
            WHEN salary >= 5000  THEN 'MEDIUM'
            ELSE 'LOW'
       END AS salary_level
FROM employees;
