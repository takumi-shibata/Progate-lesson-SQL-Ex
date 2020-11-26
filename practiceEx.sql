# 1.ユーザーの分析
-- ユーザー全体の平均年齢を取得
SELECT AVG(age)
FROM users;

-- 20歳未満の男性ユーザーの、全てのカラムの値を取得
SELECT *
FROM users
WHERE gender = 0
AND age < 20;

-- ユーザーの年齢ごとの人数と、その年齢を取得
SELECT age, COUNT(*)
FROM users
GROUP BY age;



# 2.商品の分析(1)
-- 全商品の名前を重複無く取得
SELECT DISTINCT (name)
FROM items;

-- 全商品の名前と値段を、値段が高い順に並べ替え
SELECT name, price
FROM items
ORDER BY price DESC;

-- 名前の一部に「シャツ」を含む商品の、全てのカラムの値を取得
SELECT *
FROM items
WHERE name LIKE "%シャツ";



# 3.商品の分析(2)
# ※利益の計算:「利益=価格-原価」。(例)SELECT price(価格) - cost(原価)
# ※集計関数は、四則演算と併用できる。(例)AVG(price - cost)「利益の平均値を取得」
# ※ORDER BYもまた、四則演算と併用して並び替える事ができる。(例)ORDER BY price - cost ASC「利益の低い順にデータを並び替え」

-- 全商品の名前、値段、利益を取得
SELECT name, price, price - cost
FROM items;

-- 全商品の利益の平均を取得
SELECT AVG(price - cost)
FROM items;

-- 各商品あたりの利益が上位5件の商品の名前と利益を取得
SELECT name, price - cost
FROM items
ORDER BY price - cost DESC
LIMIT 5;



# 4.商品の分析(3)
-- 「グレーパーカー」より値段が高い商品の名前と値段を取得してください
# ※サブクエリの際は、クエリで比較演算子を用いたカラムとサブクエリのSELECTのカラムが一致するようコードを書く
SELECT name, price
FROM items
WHERE price > (
  SELECT price
  FROM items
  WHERE name = "グレーパーカー"
)
;

-- 7000円以下で「グレーパーカー」より利益が高い商品を取得してください
# 等価演算子書き方注意！「以上: >=」「以下: <=」矢印はイコールの"左"！
SELECT name, price - cost
FROM items
WHERE price <= 7000
AND price - cost > (
  SELECT price - cost
  FROM items
  WHERE name = "グレーパーカー"
)
;



# 5.販売履歴の分析
-- 売れた商品ごとのidと売れた数を取得
SELECT item_id, COUNT(*)
FROM sales_records
GROUP BY item_id;

-- 売れた数が多い上位5商品のidと個数を取得してください
SELECT item_id, COUNT(*)
FROM sales_records
GROUP BY item_id
ORDER BY COUNT(*) DESC
LIMIT 5;



# 6.売上利益の分析
-- 売れた数が多い上位5商品のIDと名前、個数を取得
SELECT items.id, name, COUNT(*)
FROM sales_records
JOIN items
ON sales_records.item_id = items.id
GROUP BY items.id
ORDER BY COUNT(*) DESC
LIMIT 5;

-- このサイトの総売上と総利益を取得
SELECT SUM(price) AS "総売上" ,SUM(price - cost) AS "総利益"
FROM sales_records
JOIN items
ON sales_records.item_id = items.id;



# 7.日ごとのデータ分析
-- 日ごとの販売個数とその日付を取得
SELECT purchased_at, COUNT(*) AS "販売個数"
FROM  sales_records
GROUP BY purchased_at;

-- 日ごとの売上額とその日付を取得してください
SELECT purchased_at, SUM(price) AS "売上額"
FROM sales_records
JOIN items
ON sales_records.item_id = items.id
GROUP BY purchased_at;



# 8.複雑なユーザーデータの分析
-- 10個以上購入したユーザーIDとユーザー名、購入した商品の数を取得
SELECT users.id, name, COUNT(*) AS "購入数"
FROM sales_records
JOIN users
ON sales_records.user_id = users.id
GROUP BY users.id
HAVING COUNT(*) >= 10; # グループ分けしている時の条件の指定は「HAVING」

-- 「サンダル」を購入したユーザーのidと名前を取得
SELECT DISTINCT (users.id), (users.name)
FROM sales_records
JOIN users
ON sales_records.user_id = users.id
JOIN items
ON sales_records.item_id = items.id
WHERE items.name = "サンダル"　# グループ分けしていない時の条件の指定は「WHERE」サンダルを購入した人で絞り混んでいる
ORDER BY users.id ASC;