#!/bin/bash
#set -Ceu
#-----------------------------------------------------------------------------
# Bashの展開。
# 作成日時: 2019-04-09T12:15:40+0900
#-----------------------------------------------------------------------------
Brace() {
	echo {a..z}
	echo a{1..3}z
	echo {a..z..3}
	echo {A,J,Q,K}
	echo {{a..z},{A..Z},{0..9}}

	touch {A,B}
	find . {*.txt,*.sh}
	printf "$(printf '\\x%x' {0..127})" | od -t a
	for i in {0..9}; do echo -n "$i "; done; echo;
	rm -Rf {A,B}
}
Tilde() {
	echo ~
	echo ~+
	echo ~-
}
Parameter() {
	K=V
	echo $K
	echo ${K}

	# 変数間接展開
	VName=Key
	Key=Value
	echo ${!VName}

	# ----------------------
	# 部分文字列展開
	# ----------------------
	# デフォルト値
	unset K; echo ${K:-word}; echo $K;
	unset K; echo ${K:=word}; echo $K;
	#unset K; echo ${K:?未定義または空値です。} # ./a.sh: 行 36: K: 未定義または空値です。
	K=V; echo ${K:+word}; echo $K;

	# 部分文字列
	K=0123456789; echo -e "${K:6}\n${K:2:4}\n${K::3}\n${K: -4}\n${K: -4:2}\n${K::-1}"
	A=({0..9}); echo -e "${A[@]:6}\n${A[@]:2:4}\n${A[@]: -4}\n${A[@]: -4:2}"

	# 変数名
	K=V; Key=Val; echo "${!K*}"

	# 長さ
	K=0123456789; echo ${#K}; A=({a..z});                    # 10   変数
	A=({a..z}); echo "${#A[@]}-${#A[0]}";                    # 26-1 配列
	declare -A AA=([A]=a [B]=b); echo "${#AA[@]}-${#AA[A]}"; # 2-1  連想配列

	# 配列キー一覧
	K=0123456789; echo "${!K},${!K[@]}";                     # ,0         変数
	A=({a..z}); echo "${!A[@]},${!A[0]}";                    # 0 1 .. 25, 配列
	declare -A AA=([A]=a [B]=b); echo "${!AA[@]},${!AA[A]}"; # A B,       連想配列

	# 一致削除（前方・後方）
	K=0123456789876543210; echo ${K#*6};
	K=0123456789876543210; echo ${K##*6};
	K=0123456789876543210; echo ${K%*0};
	K=0123456789876543210; echo ${K%%*0};

	A=(ABCABC ABCXYZ XYZABC)
	# 前方一致削除
	echo ${A[@]#AB*}   # CABC CXYZ XYZABC
	echo ${A[@]##AB*}  # XYZABC
	# パターン削除の記法
	echo ${A[@]/#AB*}  # XYZABC
	# 後方一致削除
	echo ${A[@]%*ABC}  # ABC ABCXYZ XYZ
	echo ${A[@]%%*ABC} # ABCXYZ
	# パターン削除の記法
	echo ${A[@]/%*ABC} # ABCXYZ

	# 部分一致置換
	K=ABCXYZABC; echo "${K/ABC/abc}\n${K//ABC/abc}";
	K=ABCXYZABC; echo ${K/ABC/abc};
	K=ABCXYZABC; echo ${K//ABC/abc};
	K=ABCXYZABC; echo ${K/#ABC/abc};
	K=ABCXYZABC; echo ${K/%ABC/abc};

	# //#, //%, の`#`,`%`は文字として認識される
	K=#ABC; echo "${K//#ABC/abc}";
	K=%ABC; echo "${K//%ABC/abc}";
	# patternはワイルドカード。メタ文字`?`,`*`が使える
	K=ABCXYZABB; echo "${K//AB?/abc}"
	K=ABCXYZABC; echo "${K//*X/abcX}"
	# 削除（先頭のみ・末尾のみ）
	K=ABCXYZABC; echo "${K/#ABC}";
	K=ABCXYZABC; echo "${K/%ABC}";
	# 複数行に対して一行ずつ一致はできない（改行を含めて全体で「前方一致」「後方一致」「部分一致」のみ）
	K="$(echo -e 'ABCXYZABC\nXYZABCXYZ\nABC')"; echo -e "${K/#ABC/abc}";
	K="$(echo -e 'ABCXYZABC\nXYZABCXYZ\nABC')"; echo -e "${K/%ABC/abc}";
	K="$(echo -e 'ABCXYZABC\nXYZABCXYZ\nABC')"; echo -e "${K//ABC/abc}";

	A=(ABCABC ABCXYZ XYZABC)
	echo ${A[@]}           # ABCABC ABCXYZ XYZABC
	# 削除
	echo ${A[@]/BC}        # AABC AXYZ XYZA
	echo ${A[@]//BC}       # AA AXYZ XYZA
	# 置換
	echo ${A[@]/BC/bc}     # AbcABC AbcXYZ XYZAbc
	echo ${A[@]//BC/bc}    # AbcAbc AbcXYZ XYZAbc
	# 前方一致
	echo ${A[@]/#BC/bc}    # ABCABC ABCXYZ XYZABC
	echo ${A[@]/#ABC/abc}  # abcABC abcXYZ XYZabc
	# 後方一致
	echo ${A[@]/%BC/bc}    # ABCAbc ABCXYZ XYZAbc
	echo ${A[@]/%ABC/abc}  # ABCabc ABCXYZ XYZabc

	# 部分一致置換（大文字・小文字）
	K=abcABC; echo ${K^};
	K=ABCabc; echo ${K,};
	K=abcABC; echo ${K^^};
	K=ABCabc; echo ${K,,};

	K=abcABC; echo ${K^?};  # AbcABC
	K=abcABC; echo ${K^^?}; # ABCABC
	K=ABCabc; echo ${K,*};  # aBCabc
	K=ABCabc; echo ${K,,*}; # abcabc
	# 文字を指定できる。（文字のみ対象で文字列は指定不可。`${K^ab}`,`${K^^(ab)}`等で文字列`ab`を指定できない）
	K=abcABCcbcac; echo ${K^^[ab]};
}
Command() {
	K="$(ls -1)"
	K="`ls -1`"
	echo "$K"

	K="$(dirname $(dirname '/tmp/work/a.txt'))"
	K="`dirname \`dirname '/tmp/work/a.txt'\``"
	echo "$K"
}
Arithmetic() {
	# 演算子
	echo $((1+1))
	echo $((5-1))
	echo $((3*1))
	echo $((5/2))
	echo $((11%4))
	echo $((2**8))
	echo $((1+2*3))
	echo $(((1+2)*3))

	N=0
	echo $((N++))
	echo $N
	echo $((++N))
	N=0
	echo $((N--))
	echo $N
	echo $((--N))

	echo $((! 2#00 ))
	echo $((~ 2#00 ))
	echo $(( 2#0001 << 3 ))
	echo $(( 2#1000 >> 3 ))
	echo $(( 2#01 & 2#10 ))
	echo $(( 2#01 | 2#10 ))
	echo $(( 2#010 ^ 2#011 ))

	echo $(( 0 == 0 ))
	echo $(( 0 == 1 ))
	echo $(( 0 != 0 ))
	echo $(( 0 != 1 ))
	echo $(( 0 && 0 ))
	echo $(( 0 && 1 ))
	echo $(( 1 && 1 ))
	echo $(( 0 || 0 ))
	echo $(( 0 || 1 ))
	echo $(( 1 || 1 ))

	echo $(( 0 < 0 ))
	echo $(( 0 < 1 ))
	echo $(( 0 > 0 ))
	echo $(( 0 > -1 ))

	echo $(( 0 <= 0 ))
	echo $(( 0 <= 1 ))
	echo $(( 0 <= -1 ))

	echo $(( 0 >= 0 ))
	echo $(( 0 >= -1 ))
	echo $(( 0 >= 1 ))

	echo $(( 0 ? 11 : 22 ))
	echo $(( 1 ? 11 : 22 ))
	echo $(( 1,2,3 ))

	K=0
	echo $(( K += 1 ))
	echo $(( K *= 9 ))
	echo $(( K -= 3 ))
	echo $(( K /= 2 ))
	echo $(( K %= 2 ))
	echo $(( K <<= 3 ))
	echo $(( K >>= 3 ))
	echo $(( K &= $((2#11)) ))
	echo $(( K |= $((2#11)) ))
	echo $(( K ^= $((2#101)) ))

	# 基数
	# $(( 基数#値 ))
	# 2進数
	echo $(( 2#00 ))
	echo $(( 2#01 ))
	echo $(( 2#10 ))
	echo $(( 2#11 ))
	echo $(( 2#100 ))
	echo $(( 2#101 ))
	echo $(( 2#110 ))
	echo $(( 2#111 ))
	# 8進数
	echo $(( 8#00 ))
	echo $(( 8#77 ))
	# 16進数
	echo $(( 16#0 ))
	echo $(( 16#9 ))
	echo $(( 16#a ))
	echo $(( 16#A ))
	echo $(( 16#f ))
	echo $(( 16#F ))
	# {{0..9},{a..z},{A..Z}} 62進数
	echo $(( 62#0 ))
	echo $(( 62#9 ))
	echo $(( 62#z ))
	echo $(( 62#A ))
	echo $(( 62#Z ))
	echo $(( 62#10 ))
	# {{0..9},{a..z},{A..Z},@,_} 64進数
	echo $(( 64#0 ))
	echo $(( 64#9 ))
	echo $(( 64#z ))
	echo $(( 64#A ))
	echo $(( 64#Z ))
	echo $(( 64#@ ))
	echo $(( 64#_ ))
	echo $(( 64#10 ))
}
Pathname() {
	#./a.sh
	#cd ../

	touch log.txt
	ls -1 *.txt
	ls -1 *.???
	ls -1 [l]*.txt
	ls -1 [:alnum:]*.txt

	# バックアップ
	cp log{,.bak}.txt
	#cp log{,.$(date "+%Y%m%d%H%M%S")}.txt
	# リネーム
	mv log{,.append}.txt
	#mv log{,.$(date "+%Y%m%d%H%M%S")}.txt
	rm -Rf log.txt log.bak.txt log.append.txt
}
Run() {
	Funcs='Brace Parameter Tilde Command Arithmetic Pathname'
	for func in $Funcs; do echo "========== $func =========="; eval $(echo $func); done;
}
Run

