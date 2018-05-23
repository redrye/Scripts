#!/usr/bin/perl

$x = [
        [ 1, 2 ],
        [ 3, 4 ],
    ];
    
$y = [
        [ 2, -1 ],
        [ -1, 2 ],
    ];

$z = [
        [3],
        [5],
    ];
### Print product matrix of matrix_matrix_multiply()
if($ARGV[0] eq "-echelon") { print_matrix(row_reduce($matrix1)); }

if($ARGV[0] eq "-mxm") { print_matrix(matrix_matrix_multiply($matrix1, $matrix2)); }

### Print product vector or matrix of matrix_vector_multiply()
if($ARGV[0] eq "-mxv") { print_matrix(matrix_vector_multiply($matrix1, $vector)); }

### Print summation matrix of matrix_matrix_add()
if($ARGV[0] eq "-mpm") { print_matrix(matrix_matrix_add($matrix1, $vector)); }

sub matrix_matrix_add {
    my ($m1,$m2) = @_;
    my ($m1rows,$m1cols) = matdim($m1);
    my ($m2rows,$m2cols) = matdim($m2);

    unless ($m1rows == $m2rows) {  # raise exception
        die "IndexError: matrices don't match: $m1rows != $m2rows";
    }
    unless ($m1cols == $m2cols) {  # raise exception
        die "IndexError: matrices don't match: $m1cols != $m2cols";
    }
    my $result = [];
    my ($i, $j);

    for $i (range($m1rows)) {
        for $j (range($m1cols)) {
                $result->[$i][$j] = $m1->[$i][$j] + $m2->[$i][$j];
            }
        }
    

    return $result;
}

sub matrix_vector_multiply {
    my ($matrix, $vector) = @_;
    my ($vector_rows, $vector_cols) = matdim($vector);
    unless ($vector_cols == 1) {  # raise exception
        die "IndexError: vector variable not a vector vector_cols != 1";
    }
    matrix_matrix_multiply($matrix, $vector);
}

sub matrix_matrix_multiply {
    my ($m1,$m2) = @_;
    my ($m1rows,$m1cols) = matdim($m1);
    my ($m2rows,$m2cols) = matdim($m2);

    unless ($m1cols == $m2rows) {  # raise exception
        die "IndexError: matrices don't match: $m1cols != $m2rows";
    }

    my $result = [];
    my ($i, $j, $k);

    for $i (range($m1rows)) {
        for $j (range($m2cols)) {
            for $k (range($m1cols)) {
                $result->[$i][$j] += $m1->[$i][$k] * $m2->[$k][$j];
            }
        }
    }

    return $result;
}

sub rrechelon {
	my ($aref) = @_;
	my ($nr, $nc) = matdim($aref);
	my ($row, $row2, $row2_leader_pos);
	my ($row_clear_val, $row2_leader_val, $mul, $j);

	row_reduce($aref, $nr, $nc);

	for ($row = 0; $row < $nr; $row++) {
		for ($row2 = $row+1; $row2 < $nr; $row2++) {
			my @row2copy = get_row($aref, $nr, $nc, $row2);
			last if !find_leader_pos(\@row2copy, $nc, \$row2_leader_pos);

			$row2_leader_val = $$aref[$row2][$row2_leader_pos];
			$row_clear_val = $$aref[$row][$row2_leader_pos];
			next if (tol_zero($row_clear_val));

			$mul = $row_clear_val / $row2_leader_val;
			for ($j = 0; $j < $nc; $j++) {
				$$aref[$row][$j] -= $$aref[$row2][$j] * $mul;
			}
		}
	}
 
}
sub row_reduce {
    my($matrix) = @_;
    my($rows, $cols) = matdim($matrix);
    my($top_row, $left_col, $current_row);
    for($top_row = 0, $left_col; ($top_row < $rows) && ($left_col < $cols);) {
        my $pivot_row = $top_row;
        my $pivot = 0;
        while(!$pivot && ($pivot_row < $rows)) {
            if(total_not_zero($matrix->[$pivot_row][$left_col])) {
                if($top_row != $pivot_row) {
                    my @temp = @$matrix[$top_row];
                    @$matrix[$top_row] = @$matrix[$pivot_row];
                    @$matrix[$pivot_row] = @temp;
                }
                $pivot = 1;
            } else {
                $pivot_row++;
            }
        }
        if(!$pivot) {
            $left_col++;
            next;
        }
        my $top_row_lead == $matrix->[$top_row][$left_col];
        if(total_not_zero($top_row_lead)) {
            my $inv = 1/$top_row_lead;
            for $i (range($cols)) {
                $matrix->[$top_row][$i] *= $inv;
            }
            $top_row_lead = $matrix->[$top_row][$left_col];
            for($current_row = $top_row + 1; $current_row < $rows; $current_row++) {
                my $current_row_lead = $matrix->[$current_row][$left_col];
                for $i (range($cols)) {
                    $matrix->[$current_row][$i] * $top_row_lead - $matrix->[$current_row][$i] * $current_row_lead;
                }
            }
        }
        $left_col++;
        $top_row++;
    }
}
sub range { 0 .. ($_[0] - 1) }

sub veclen {
    my $ary_ref = $_[0];
    my $type = ref $ary_ref;
    if ($type ne "ARRAY") { die "$type is bad array ref for $ary_ref" }
    return scalar(@$ary_ref);
}

sub matdim {
    my $matrix = $_[0];
    my $rows = veclen($matrix);
    my $cols = veclen($matrix->[0]);
    return ($rows, $cols);
}

sub print_matrix {
    my($matrix) = @_;
    my($rdim, $cdim) = matdim($matrix);
    for $i (range($rdim)) {
        for $j (range($cdim)) {
            print "$matrix->[$i][$j]  ";
        }
        print "\n";
    }
}
    
