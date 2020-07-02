! subroutine write3DData
! このサブルーチンは3Dデータをvtk形式で出力します。Paraviewなどの可視化ソフトで読み取ってグラフにできます。
! データを直接バイナリで出力するため、テキストデータと異なり人間の目では理解は難しいですが、非常に高速に処理できます。
! 使用方法は次のいずれか
! 1. 同梱のbiny_data_ouf.f90をsrcの中にある既存のbiny_data_out.f90に置き換えることによって使用できます。
! 2. plotのソースコードでbiny_data_outもしくはtext_data_outを呼び出している部分をこのサブルーチンを呼び出すようにしてください。
! filename : 出力するファイル名。拡張子はvtkとすること。
! A        : 出力するデータ。Aは実数の3次元配列。
! system_lx, system_ly, system_lz : EPICで通常使用されるシステムサイズを指定する。
subroutine write_3d_data(filename, A, system_lx, system_ly, system_lz)
  implicit none

  ! open文で使用する装置番号
  integer, parameter::file_id=100
  ! x, y, zのデータ数と, 全データ数nnn
  integer Nx, Ny, Nz, nnn
  ! システムサイズ及び、メッシュサイズ
  real(kind=8) system_lx, system_ly, system_lz, spacingx, spacingy, spacingz
  ! 3Dデータ
  real(kind=8) A(:, :, :)
  ! 出力用のダミー変数
  character(1) dummy
  ! ファイル名, 出力時に使用するバッファ
  character(len=128) filename, buffer

  Nx = size(A, 1)
  Ny = size(A, 2)
  Nz = size(A, 3)
  nnn = Nx*Ny*Nz

  ! メッシュサイズ計算
  spacingx = system_lx/Nx
  spacingy = system_ly/Ny
  spacingz = system_lz/Nz

  ! vtkに書きこみ
  open(unit=file_id, file=filename, form="unformatted", access="stream", convert="big_endian")
  write(file_id) '# vtk DataFile Version 3.0', new_line(dummy)
  write(file_id) '3D Data', new_line(dummy)
  write(file_id) 'BINARY', new_line(dummy)
  write(file_id) 'DATASET STRUCTURED_POINTS', new_line(dummy)

  write(buffer,  '("DIMENSIONS",i4.2,i4.2,i4.2)') Nx, Ny, Nz

  write(file_id) trim(buffer), new_line(dummy)
  write(file_id) 'ORIGIN 0 0 0', new_line(dummy)

  write(buffer,  '("SPACING",i4.2,i4.2,i4.2)') spacingx, spacingy, spacingz

  write(file_id) trim(buffer), new_line(dummy)

  write(buffer,  '("POINT_DATA ",i10.2)') nnn

  write(file_id) trim(buffer), new_line(dummy)
  write(file_id) 'SCALARS volume_scalars double 1', new_line(dummy)
  write(file_id) 'LOOKUP_TABLE default', new_line(dummy)
  write(file_id) A
  close(file_id)

end subroutine
