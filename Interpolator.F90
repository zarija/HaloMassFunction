!--------------------------------------------------------------------------
! Linear interpolation

! use as:  y = interpolate(n, xx, yy, x)

! where: 
!        n is the size of arrays xx and yy
!        xx is the array of points (monotonically increasing or decreasing)
!        yy is the array of corresponding function values.
!        x is the point for which interpolation is needed


module ModuleInterpolator

implicit none
public  :: interpolate

contains

double precision function interpolate(n, xx, yy, x)
implicit none
integer, intent(in) :: n
double precision, intent(in) :: x
double precision, dimension(:), intent(in) :: xx, yy
integer :: inc, jhi, jm
integer, save :: jlo=0

! two edge cases which include extrapolation
if (x .lt. xx(2)) then
   interpolate = (yy(1)-yy(2))/(xx(1)-xx(2)) * (x-xx(1)) + yy(1)
   RETURN
else if (x .gt. xx(n-1)) then
   interpolate = (yy(n-1)-yy(n))/(xx(n-1)-xx(n)) * (x-xx(n-1)) + yy(n-1)
   RETURN
endif

! general case
if (jlo .le. 0 .or. jlo .ge. n) then
   jlo = 0
   jhi = n+1
else
   inc = 1
   if (x .ge. xx(jlo)) then  ! move up
      do
         jhi = jlo + inc
         if (jhi .gt. n) then
            jhi = n+1
            EXIT
         else
            if (x .lt. xx(jhi)) EXIT
            jlo = jhi
            inc = 2*inc
         endif
      enddo
   else  ! move down
      jhi = jlo
      do
         jlo = jhi - inc
         if (jlo .lt. 1) then
            jlo = 0
            EXIT
         else
            if (x .ge. xx(jlo)) EXIT
            jhi = jlo
            inc = 2*inc
         endif
      enddo
   endif
endif

do while (jhi-jlo .gt. 1)  ! bisect
   jm = (jhi+jlo) / 2
   if (x .ge. xx(jm)) then
      jlo = jm
   else
      jhi = jm
   endif
enddo
interpolate = (yy(jlo)-yy(jlo+1))/(xx(jlo)-xx(jlo+1)) * (x-xx(jlo)) + yy(jlo)
end function interpolate

end module ModuleInterpolator
