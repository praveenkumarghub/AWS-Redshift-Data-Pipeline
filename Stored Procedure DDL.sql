
CREATE OR REPLACE PROCEDURE dev.public.sp_process_coffee_sales()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Step 1: Create external schema if not exists
    BEGIN
        EXECUTE 'CREATE EXTERNAL SCHEMA IF NOT EXISTS ex_coffee_sales
                 FROM DATA CATALOG
                 DATABASE ''samples3db''
                 IAM_ROLE ''arn:aws:iam::178795994454:role/service-role/AmazonRedshift-CommandsAccessRole-20250713T084422''';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'External schema creation failed or already exists: %', SQLERRM;
    END;

    -- Step 2: Drop existing target table
    BEGIN
        EXECUTE 'DROP TABLE IF EXISTS dev.public.agg_coffee_sales';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Drop table failed: %', SQLERRM;
    END;

    -- Step 3: Create target table
    BEGIN
        EXECUTE 'CREATE TABLE dev.public.agg_coffee_sales (
                    month INT,
                    week VARCHAR,
                    cash_type VARCHAR,
                    total_sum INT
                )';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Create table failed: %', SQLERRM;
    END;

    -- Step 4: Insert transformed data
    BEGIN
        EXECUTE '
            INSERT INTO dev.public.agg_coffee_sales (
                month,
                week,
                cash_type,
                total_sum
            )
            SELECT 
                month, 
                CASE 
                    WHEN custom_week = 1 THEN ''week_1''
                    WHEN custom_week = 2 THEN ''week_2''
                    WHEN custom_week = 3 THEN ''week_3''
                    ELSE ''week_4''
                END AS week,
                cash_type,
                SUM(money) AS total_sum
            FROM (
                SELECT  
                    EXTRACT(MONTH FROM date) AS month,
                    FLOOR((EXTRACT(DAY FROM date) - 1) / 7) + 1 AS custom_week,
                    cash_type,
                    money,
                    coffee_name
                FROM ex_coffee_sales.coffee_sales
            ) a
            GROUP BY month, week, cash_type';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Insert failed: %', SQLERRM;
    END;
END;
$$;
