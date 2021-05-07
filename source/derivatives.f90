module derivatives
    implicit none



    real,             parameter                 :: ZERO = 0.0, ONE = 1.0, TWO = 2.0, THREE = 3.0,  &
                                                   FOUR = 4.0, FIVE = 5.0, SIX = 6.0, SEVEN = 7.0, &
                                                   EIGHT = 8.0, NINE = 9.0, TEN = 10.0



    contains




    !
    ! Function to compute first basis function of a
    ! cubic B-spline with a spline parameter value t
    !
    !-----------------------------------------------------------------------------------------------
    real function B0(t)

            real,               intent(in)      :: t


            ! Compute basis function
            B0                          = ((1 - t)**3)/6.0

    end function B0
    !-----------------------------------------------------------------------------------------------

    !
    ! Function to compute second basis function of a
    ! cubic B-spline with a spline parameter value t
    !
    !-----------------------------------------------------------------------------------------------
    real function B1(t)

            real,               intent(in)      :: t


            ! Compute basis function
            B1                          = ((3.0 * (t**3)) - (6.0 * (t**2)) + 4.0)/6.0

    end function B1
    !-----------------------------------------------------------------------------------------------

    !
    ! Function to compute third basis function of a
    ! cubic B-spline with a spline parameter value t
    !
    !-----------------------------------------------------------------------------------------------
    real function B2(t)

            real,               intent(in)      :: t


            ! Compute basis function
            B2                          = ((-3.0 * (t**3)) + (3.0 * (t**2)) + (3.0 * t) + 1.0)/6.0

    end function B2
    !-----------------------------------------------------------------------------------------------

    !
    ! Function to compute fourth basis function of a
    ! cubic B-spline with a spline parameter value t
    !
    !-----------------------------------------------------------------------------------------------
    real function B3(t)

            real,               intent(in)      :: t


            ! Compute basis function
            B3                          = (t**3)/6.0

    end function B3
    !-----------------------------------------------------------------------------------------------






    !
    ! Function to find intermediate knot for spline evaluation
    !
    ! Input parameters: tt - t value at which spline is to be evaluated
    !                   t  - independent variable values
    !                   n  - number of spline points
    !
    !------------------------------------------------------------------------------------
    integer function find_knt_copy (tt, t, n)

        integer,                intent (in)     :: n
        real,                   intent (in)     :: t(n), tt

        ! Local variables
        integer                                 :: knt1, knt2, m
        real,   parameter                       :: tol = 10E-16


        knt1                            = 1
        knt2                            = n

        do while (knt2 - knt1 > 1)

            m                           = (knt2 + knt1)/2
            if (tt < t(m)) then
                knt2                    = m
            else
                knt1                    = m
            end if

            if (abs(tt - t(m)) < 10E-16) exit
            !if (tt .eq. t(m)) exit

        end do

        find_knt_copy                   = knt1


    end function find_knt_copy
    !------------------------------------------------------------------------------------






    !
    ! This subroutine computes groupings of terms
    ! used to compute the quantity angle which is
    ! the integral of the second derivative of the
    ! mean-line
    !
    ! Input parameters: t   - B-spline parameter value
    !
    !-----------------------------------------------------------------------------------------------
    subroutine angle_t_terms (t, t_terms)

        real,                   intent(in)      :: t
        real,                   intent(inout)   :: t_terms(4, 4)


        t_terms(1, 1)                   = t**6/72 - t**5/12 + 5*t**4/24 - 5*t**3/18 + 5*t**2/24 - t/12
        t_terms(1, 2)                   = -t**6/24 + 13*t**5/60 - 7*t**4/16 + 5*t**3/12 - t**2/6
        t_terms(1, 3)                   = t**6/24 - 11*t**5/60 + 7*t**4/24 - t**3/6 - t**2/24 + t/12
        t_terms(1, 4)                   = -t**6/72 + t**5/20 - t**4/16 + t**3/36

        t_terms(2, 1)                   = -t**6/24 + t**5/5 - 5*t**4/16 + t**3/18 + t**2/3 - t/3
        t_terms(2, 2)                   = t**6/8 - t**5/2 + t**4/2 + t**3/3 - 2*t**2/3
        t_terms(2, 3)                   = -t**6/8 + 2*t**5/5 - 3*t**4/16 - t**3/2 + t**2/3 + t/3
        t_terms(2, 4)                   = t**6/24 - t**5/10 + t**3/9

        t_terms(3, 1)                   = t**6/24 - 3*t**5/20 + t**4/8 + t**3/18 - t**2/24 - t/12
        t_terms(3, 2)                   = -t**6/8 + 7*t**5/20 - t**4/16 - t**3/4 - t**2/6
        t_terms(3, 3)                   = t**6/8 - t**5/4 - t**4/8 + t**3/6 + 5*t**2/24 + t/12
        t_terms(3, 4)                   = -t**6/24 + t**5/20 + t**4/16 + t**3/36

        t_terms(4, 1)                   = -t**6/72 + t**5/30 - t**4/48
        t_terms(4, 2)                   = t**6/24 - t**5/15
        t_terms(4, 3)                   = -t**6/24 + t**5/30 + t**4/48
        t_terms(4, 4)                   = t**6/72


    end subroutine angle_t_terms
    !-----------------------------------------------------------------------------------------------






    !
    ! This subroutine computes the derivatives
    ! of the groupings computed in angle_t_terms
    ! wrt t
    !
    ! Input parameters: t   - B-spline parameter value
    !
    !-----------------------------------------------------------------------------------------------
    subroutine angle_t_terms_ders (t, t_terms)

        real,                   intent(in)      :: t
        real,                   intent(inout)   :: t_terms(4, 4)


        t_terms(1, 1)                   = ((t**5)/12.0) - ((FIVE/12.0) * (t**4)) + ((FIVE/SIX) * (t**3)) - &
                                          ((FIVE/SIX) * (t**2)) + ((FIVE/12.0) * t) - (ONE/12.0)
        t_terms(1, 2)                   = -((t**5)/FOUR) + ((13.0/12.0) * (t**4)) - ((SEVEN/FOUR) * (t**3)) + &
                                          ((FIVE/FOUR) * (t**2)) - (t/THREE)
        t_terms(1, 3)                   = ((t**5)/FOUR) - ((11.0/12.0) * (t**4)) + ((SEVEN/SIX) * (t**3)) - &
                                          ((t**2)/TWO) - (t/12.0) + (ONE/12.0)
        t_terms(1, 4)                   = -((t**5)/12.0) + ((t**4)/FOUR) - ((t**3)/FOUR) + ((t**2)/12.0)

        t_terms(2, 1)                   = -((t**5)/FOUR) + (t**4) - ((FIVE/FOUR) * (t**3)) + ((t**2)/SIX) + &
                                          ((TWO/THREE) * t) - (ONE/THREE)
        t_terms(2, 2)                   = ((THREE/FOUR) * (t**5)) - ((FIVE/TWO) * (t**4)) + (TWO * (t**3)) + (t**2) - &
                                          ((FOUR/THREE) * t)
        t_terms(2, 3)                   = -((THREE/FOUR) * (t**5)) + (TWO * (t**4)) - ((THREE/FOUR) * (t**3)) - &
                                          ((THREE/TWO) * (t**2)) + ((TWO/THREE) * t) + (ONE/THREE)
        t_terms(2, 4)                   = ((t**5)/FOUR) - ((t**4)/TWO) + ((t**2)/THREE)

        t_terms(3, 1)                   = ((t**5)/FOUR) - ((THREE/FOUR) * (t**4)) + ((t**3)/TWO) + ((t**2)/SIX) - &
                                          (t/12.0) - (ONE/12.0)
        t_terms(3, 2)                   = -((THREE/FOUR) * (t**5)) + ((SEVEN/FOUR) * (t**4)) - ((t**3)/FOUR) - &
                                          ((THREE/FOUR) * (t**2)) - (t/THREE)
        t_terms(3, 3)                   = ((THREE/FOUR) * (t**5)) - ((FIVE/FOUR) * (t**4)) - ((t**3)/TWO) + ((t**2)/TWO) + &
                                          ((FIVE/12.0) * t) + (ONE/12.0)
        t_terms(3, 4)                   = -((t**5)/FOUR) + ((t**4)/FOUR) + ((t**3)/FOUR) + ((t**2)/12.0)

        t_terms(4, 1)                   = -((t**5)/12.0) + ((t**4)/SIX) - ((t**3)/12.0)
        t_terms(4, 2)                   = ((t**5)/FOUR) - ((t**4)/THREE)
        t_terms(4, 3)                   = -((t**5)/FOUR) + ((t**4)/SIX) + ((t**3)/12.0)
        t_terms(4, 4)                   = (t**5)/12.0


    end subroutine angle_t_terms_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! This subroutine computes groupings of terms
    ! used to compute the quantity camber which is
    ! the double integration of the second derivative
    ! of the mean-line
    !
    ! Input parameters: t   - spline parameter value
    !
    !-----------------------------------------------------------------------------------------------
    subroutine camber_t_terms (t, t_terms)

        real,                   intent(in)      :: t
        real,                   intent(inout)   :: t_terms(4, 4, 4)


        t_terms(1, 1, 1)                = -t**9/1296 + t**8/144 - t**7/36 + 7*t**6/108 - 7*t**5/72 + 7*t**4/72 - t**3/16 + &
                                           t**2/48
        t_terms(1, 1, 2)                = t**9/432 - 11*t**8/576 + 23*t**7/336 - 5*t**6/36 + 25*t**5/144 - 13*t**4/96 +    &
                                          t**3/18
        t_terms(1, 1, 3)                = -t**9/432 + 5*t**8/288 - t**7/18 + 7*t**6/72 - 7*t**5/72 + 7*t**4/144 + t**3/144 - &
                                           t**2/48
        t_terms(1, 1, 4)                = t**9/1296 - t**8/192 + 5*t**7/336 - 5*t**6/216 + t**5/48 - t**4/96
        t_terms(1, 2, 1)                = t**9/432 - 3*t**8/160 + 73*t**7/1120 - 181*t**6/1440 + 23*t**5/160 - 3*t**4/32 + &
                                          t**3/36
        t_terms(1, 2, 2)                = -t**9/144 + 49*t**8/960 - 523*t**7/3360 + t**6/4 - 13*t**5/60 + t**4/12
        t_terms(1, 2, 3)                = t**9/144 - 11*t**8/240 + 409*t**7/3360 - 229*t**6/1440 + 43*t**5/480 + t**4/96 - &
                                          t**3/36
        t_terms(1, 2, 4)                = -t**9/432 + 13*t**8/960 - t**7/32 + 5*t**6/144 - t**5/60
        t_terms(1, 3, 1)                = -t**9/432 + t**8/60 - t**7/20 + 7*t**6/90 - 7*t**5/120 + 5*t**3/144 - t**2/48
        t_terms(1, 3, 2)                = t**9/144 - 43*t**8/960 + 193*t**7/1680 - 5*t**6/36 + 13*t**5/240 + 5*t**4/96 - t**3/18
        t_terms(1, 3, 3)                = -t**9/144 + 19*t**8/480 - 3*t**7/35 + 3*t**6/40 + t**5/120 - t**4/16 + t**3/48 + &
                                           t**2/48
        t_terms(1, 3, 4)                = t**9/432 - 11*t**8/960 + t**7/48 - t**6/72 - t**5/240 + t**4/96
        t_terms(1, 4, 1)                = t**9/1296 - 7*t**8/1440 + 127*t**7/10080 - 73*t**6/4320 + 17*t**5/1440 - t**4/288
        t_terms(1, 4, 2)                = -t**9/432 + 37*t**8/2880 - 31*t**7/1120 + t**6/36 - t**5/90
        t_terms(1, 4, 3)                = t**9/432 - t**8/90 + 197*t**7/10080 - 19*t**6/1440 - t**5/1440 + t**4/288
        t_terms(1, 4, 4)                = -t**9/1296 + t**8/320 - t**7/224 + t**6/432

        t_terms(2, 1, 1)                = t**9/432 - 17*t**8/960 + 181*t**7/3360 - 317*t**6/4320 + 13*t**5/1440 + 17*t**4/144 - &
                                          t**3/6 + t**2/12
        t_terms(2, 1, 2)                = -t**9/144 + 23*t**8/480 - 139*t**7/1120 + 17*t**6/144 + 7*t**5/90 - 7*t**4/24 +       &
                                           2*t**3/9
        t_terms(2, 1, 3)                = t**9/144 - 41*t**8/960 + 311*t**7/3360 - 71*t**6/1440 - 173*t**5/1440 + 31*t**4/144 - &
                                          t**3/18 - t**2/12
        t_terms(2, 1, 4)                = -t**9/432 + t**8/80 - 5*t**7/224 + t**6/216 + t**5/30 - t**4/24
        t_terms(2, 2, 1)                = -t**9/144 + 3*t**8/64 - 13*t**7/112 + 7*t**6/72 + t**5/12 - 5*t**4/24 + t**3/9
        t_terms(2, 2, 2)                = t**9/48 - t**8/8 + t**7/4 - t**6/12 - t**5/3 + t**4/3
        t_terms(2, 2, 3)                = -t**9/48 + 7*t**8/64 - 19*t**7/112 - t**6/24 + 19*t**5/60 - t**4/8 - t**3/9
        t_terms(2, 2, 4)                = t**9/144 - t**8/32 + t**7/28 + t**6/36 - t**5/15
        t_terms(2, 3, 1)                = t**9/144 - 13*t**8/320 + 89*t**7/1120 - 11*t**6/480 - 11*t**5/96 + 5*t**4/48 +        &
                                          t**3/18 - t**2/12
        t_terms(2, 3, 2)                = -t**9/48 + 17*t**8/160 - 173*t**7/1120 - t**6/16 + 3*t**5/10 - t**4/24 - 2*t**3/9
        t_terms(2, 3, 3)                = t**9/48 - 29*t**8/320 + 99*t**7/1120 + 61*t**6/480 - 7*t**5/32 - 5*t**4/48 + t**3/6 + &
                                          t**2/12
        t_terms(2, 3, 4)                = -t**9/144 + t**8/40 - 3*t**7/224 - t**6/24 + t**5/30 + t**4/24
        t_terms(2, 4, 1)                = -t**9/432 + 11*t**8/960 - 29*t**7/1680 - t**6/1080 + t**5/45 - t**4/72
        t_terms(2, 4, 2)                = t**9/144 - 7*t**8/240 + t**7/35 + t**6/36 - 2*t**5/45
        t_terms(2, 4, 3)                = -t**9/144 + 23*t**8/960 - 19*t**7/1680 - 13*t**6/360 + t**5/45 + t**4/72
        t_terms(2, 4, 4)                = t**9/432 - t**8/160 + t**6/108

        t_terms(3, 1, 1)                = -t**9/432 + 7*t**8/480 - t**7/30 + 31*t**6/1080 + t**5/360 - t**4/144 - t**3/48 + &
                                           t**2/48
        t_terms(3, 1, 2)                = t**9/144 - 37*t**8/960 + 39*t**7/560 - t**6/36 - 5*t**5/144 - t**4/96 + t**3/18
        t_terms(3, 1, 3)                = -t**9/144 + t**8/30 - 19*t**7/420 - t**6/180 + 13*t**5/360 + t**4/36 - 5*t**3/144 - &
                                           t**2/48
        t_terms(3, 1, 4)                = t**9/432 - 3*t**8/320 + t**7/112 + t**6/216 - t**5/240 - t**4/96
        t_terms(3, 2, 1)                = t**9/144 - 3*t**8/80 + 71*t**7/1120 - 3*t**6/160 - 13*t**5/480 - t**4/96 + t**3/36
        t_terms(3, 2, 2)                = -t**9/48 + 31*t**8/320 - 127*t**7/1120 - t**6/24 + t**5/20 + t**4/12
        t_terms(3, 2, 3)                = t**9/48 - 13*t**8/160 + 61*t**7/1120 + 13*t**6/160 - t**5/160 - 7*t**4/96 - t**3/36
        t_terms(3, 2, 4)                = -t**9/144 + 7*t**8/320 - t**7/224 - t**6/48 - t**5/60
        t_terms(3, 3, 1)                = -t**9/144 + t**8/32 - t**7/28 - t**6/72 + t**5/40 + t**4/48 - t**3/144 - t**2/48
        t_terms(3, 3, 2)                = t**9/48 - 5*t**8/64 + 5*t**7/112 + t**6/12 - t**5/240 - 7*t**4/96 - t**3/18
        t_terms(3, 3, 3)                = -t**9/48 + t**8/16 - t**6/12 - t**5/24 + t**4/24 + t**3/16 + t**2/48
        t_terms(3, 3, 4)                = t**9/144 - t**8/64 - t**7/112 + t**6/72 + t**5/48 + t**4/96
        t_terms(3, 4, 1)                = t**9/432 - t**8/120 + 19*t**7/3360 + 17*t**6/4320 - t**5/1440 - t**4/288
        t_terms(3, 4, 2)                = -t**9/144 + 19*t**8/960 - t**7/1120 - t**6/72 - t**5/90
        t_terms(3, 4, 3)                = t**9/144 - 7*t**8/480 - 31*t**7/3360 + 11*t**6/1440 + 17*t**5/1440 + t**4/288
        t_terms(3, 4, 4)                = -t**9/432 + t**8/320 + t**7/224 + t**6/432

        t_terms(4, 1, 1)                = t**9/1296 - 11*t**8/2880 + 73*t**7/10080 - t**6/160 + t**5/480
        t_terms(4, 1, 2)                = -t**9/432 + 7*t**8/720 - 47*t**7/3360 + t**6/144
        t_terms(4, 1, 3)                = t**9/432 - 23*t**8/2880 + 83*t**7/10080 - t**6/1440 - t**5/480
        t_terms(4, 1, 4)                = -t**9/1296 + t**8/480 - t**7/672
        t_terms(4, 2, 1)                = -t**9/432 + 3*t**8/320 - t**7/80 + t**6/180
        t_terms(4, 2, 2)                = t**9/144 - 11*t**8/480 + 2*t**7/105
        t_terms(4, 2, 3)                = -t**9/144 + 17*t**8/960 - 11*t**7/1680 - t**6/180
        t_terms(4, 2, 4)                = t**9/432 - t**8/240
        t_terms(4, 3, 1)                = t**9/432 - 7*t**8/960 + t**7/160 + t**6/1440 - t**5/480
        t_terms(4, 3, 2)                = -t**9/144 + t**8/60 - 17*t**7/3360 - t**6/144
        t_terms(4, 3, 3)                = t**9/144 - 11*t**8/960 - 3*t**7/1120 + t**6/160 + t**5/480
        t_terms(4, 3, 4)                = -t**9/432 + t**8/480 + t**7/672
        t_terms(4, 4, 1)                = -t**9/1296 + t**8/576 - t**7/1008
        t_terms(4, 4, 2)                = t**9/432 - t**8/288
        t_terms(4, 4, 3)                = -t**9/432 + t**8/576 + t**7/1008
        t_terms(4, 4, 4)                = t**9/1296


    end subroutine camber_t_terms
    !-----------------------------------------------------------------------------------------------






    !
    ! This subroutine computes the derivatives
    ! of the groupings computed in camber_t_terms
    ! wrt t
    !
    ! Input parameters: t   - spline parameter value
    !
    !-----------------------------------------------------------------------------------------------
    subroutine camber_t_terms_ders (t, t_terms)

        real,                   intent(in)      :: t
        real,                   intent(inout)   :: t_terms(4, 4, 4)

        ! Local variables
        real                                    :: t2, t3, t4, t5, t6, t7, t8


        ! Temporary variables
        t2                              = t**2
        t3                              = t**3
        t4                              = t**4
        t5                              = t**5
        t6                              = t**6
        t7                              = t**7
        t8                              = t**8


        !
        ! Compute derivatives
        !
        !t_terms(1, 1, 1)                = -t**9/1296 + t**8/144 - t**7/36 + 7*t**6/108 - 7*t**5/72 + 7*t**4/72 - t**3/16 + &
        !                                   t**2/48
        t_terms(1, 1, 1)                = (-t8/144.0) + (t7/18.0) - ((SEVEN/36.0) * t6) + ((SEVEN/18.0) * t5) - &
                                          ((35.0/72.0) * t4) + ((SEVEN/18.0) * t3) - ((THREE/16.0) * t2) + (t/24.0)
        !t_terms(1, 1, 2)                = t**9/432 - 11*t**8/576 + 23*t**7/336 - 5*t**6/36 + 25*t**5/144 - 13*t**4/96 +    &
        !                                  t**3/18
        t_terms(1, 1, 2)                = (t8/48.0) - ((11.0/72.0) * t7) + ((23.0/48.0) * t6) - ((FIVE/SIX) * t5) + &
                                          ((125.0/144.0) * t4) - ((13.0/24.0) * t3) + (t2/SIX)
        !t_terms(1, 1, 3)                = -t**9/432 + 5*t**8/288 - t**7/18 + 7*t**6/72 - 7*t**5/72 + 7*t**4/144 + t**3/144 - &
        !                                   t**2/48
        t_terms(1, 1, 3)                = (-t8/48.0) + ((FIVE/36.0) * t7) - ((SEVEN/18.0) * t6) + ((SEVEN/12.0) * t5) - &
                                          ((35.0/72.0) * t4) + ((SEVEN/36.0) * t3) + (t2/48.0) - (t/24.0)
        !t_terms(1, 1, 4)                = t**9/1296 - t**8/192 + 5*t**7/336 - 5*t**6/216 + t**5/48 - t**4/96
        t_terms(1, 1, 4)                = (t8/144.0) - (t7/24.0) + ((FIVE/48.0) * t6) - ((FIVE/36.0) * t5) + &
                                          ((FIVE/48.0) * t4) - (t3/24.0)

        !t_terms(1, 2, 1)                = t**9/432 - 3*t**8/160 + 73*t**7/1120 - 181*t**6/1440 + 23*t**5/160 - 3*t**4/32 + &
        !                                  t**3/36
        t_terms(1, 2, 1)                = (t8/48.0) - ((THREE/20.0) * t7) + ((73.0/160.0) * t6) - ((181.0/240.0) * t5) + &
                                          ((23.0/32.0) * t4) - ((THREE/EIGHT) * t3) + (t2/12.0)
        !t_terms(1, 2, 2)                = -t**9/144 + 49*t**8/960 - 523*t**7/3360 + t**6/4 - 13*t**5/60 + t**4/12
        t_terms(1, 2, 2)                = (-t8/16.0) + ((49.0/120.0) * t7) - ((523.0/480.0) * t6) + ((THREE/TWO) * t5) - &
                                          ((13.0/12.0) * t4) + (t3/THREE)
        !t_terms(1, 2, 3)                = t**9/144 - 11*t**8/240 + 409*t**7/3360 - 229*t**6/1440 + 43*t**5/480 + t**4/96 - &
        !                                  t**3/36
        t_terms(1, 2, 3)                = (t8/16.0) - ((11.0/30.0) * t7) + ((409.0/480.0) * t6) - ((229/240.0) * t5) + &
                                          ((43.0/96.0) * t4) + (t3/24.0) - (t2/12.0)
        !t_terms(1, 2, 4)                = -t**9/432 + 13*t**8/960 - t**7/32 + 5*t**6/144 - t**5/60
        t_terms(1, 2, 4)                = (-t8/48.0) + ((13.0/120.0) * t7) - ((SEVEN/32.0) * t6) + ((FIVE/24.0) * t5) - (t4/12.0)
        !t_terms(1, 3, 1)                = -t**9/432 + t**8/60 - t**7/20 + 7*t**6/90 - 7*t**5/120 + 5*t**3/144 - t**2/48
        t_terms(1, 3, 1)                = (-t8/48.0) + ((TWO/15.0) * t7) - ((SEVEN/20.0) * t6) + ((SEVEN/15.0) * t5) - &
                                          ((SEVEN/24.0) * t4) + ((FIVE/48.0) * t2) - (t/24.0)
        !t_terms(1, 3, 2)                = t**9/144 - 43*t**8/960 + 193*t**7/1680 - 5*t**6/36 + 13*t**5/240 + 5*t**4/96 - t**3/18
        t_terms(1, 3, 2)                = (t8/16.0) - ((43.0/120.0) * t7) + ((193.0/240.0) * t6) - ((FIVE/SIX) * t5) + &
                                          ((13.0/48.0) * t4) + ((FIVE/24.0) * t3) - (t2/SIX)
        !t_terms(1, 3, 3)                = -t**9/144 + 19*t**8/480 - 3*t**7/35 + 3*t**6/40 + t**5/120 - t**4/16 + t**3/48 + &
        !                                   t**2/48
        t_terms(1, 3, 3)                = (-t8/16.0) + ((19.0/60.0) * t7) - ((THREE/FIVE) * t6) + ((NINE/20.0) * t5) + &
                                          (t4/24.0) - (t3/FOUR) + (t2/16.0) + (t/24.0)
        !t_terms(1, 3, 4)                = t**9/432 - 11*t**8/960 + t**7/48 - t**6/72 - t**5/240 + t**4/96
        t_terms(1, 3, 4)                = (t8/48.0) - ((11.0/120.0) * t7) + ((SEVEN/48.0) * t6) - (t5/12.0) - (t4/48.0) + &
                                          (t3/24.0)
        !t_terms(1, 4, 1)                = t**9/1296 - 7*t**8/1440 + 127*t**7/10080 - 73*t**6/4320 + 17*t**5/1440 - t**4/288
        t_terms(1, 4, 1)                = (t8/144.0) - ((SEVEN/180.0) * t7) + ((127.0/1440.0) * t6) - ((73.0/720.0) * t5) + &
                                          ((17.0/288.0) * t4) - (t3/72.0)
        !t_terms(1, 4, 2)                = -t**9/432 + 37*t**8/2880 - 31*t**7/1120 + t**6/36 - t**5/90
        t_terms(1, 4, 2)                = (-t8/48.0) + ((37.0/360.0) * t7) - ((31.0/160.0) * t6) + (t5/SIX) - (t4/18.0)
        !t_terms(1, 4, 3)                = t**9/432 - t**8/90 + 197*t**7/10080 - 19*t**6/1440 - t**5/1440 + t**4/288
        t_terms(1, 4, 3)                = (t8/48.0) - ((FOUR/45.0) * t7) + ((197.0/1440.0) * t6) - ((19.0/240.0) * t5) - &
                                          (t4/288.0) + (t3/72.0)
        !t_terms(1, 4, 4)                = -t**9/1296 + t**8/320 - t**7/224 + t**6/432
        t_terms(1, 4, 4)                = (-t8/144.0) + (t7/40.0) - (t6/32.0) + (t5/72.0)

        !t_terms(2, 1, 1)                = t**9/432 - 17*t**8/960 + 181*t**7/3360 - 317*t**6/4320 + 13*t**5/1440 + 17*t**4/144 - &
        !                                  t**3/6 + t**2/12
        t_terms(2, 1, 1)                = (t8/48.0) - ((17.0/120.0) * t7) + ((181.0/480.0) * t6) - ((317.0/720.0) * t5) + &
                                          ((13.0/288.0) * t4) + ((17.0/36.0) * t3) - (t2/TWO) + (t/SIX)
        !t_terms(2, 1, 2)                = -t**9/144 + 23*t**8/480 - 139*t**7/1120 + 17*t**6/144 + 7*t**5/90 - 7*t**4/24 +       &
        !                                   2*t**3/9
        t_terms(2, 1, 2)                = (-t8/16.0) + ((23.0/60.0) * t7) - ((139.0/160.0) * t6) + ((17.0/24.0) * t5) + &
                                          ((SEVEN/18.0) * t4) - ((SEVEN/SIX) * t3) + ((TWO/THREE) * t2)
        !t_terms(2, 1, 3)                = t**9/144 - 41*t**8/960 + 311*t**7/3360 - 71*t**6/1440 - 173*t**5/1440 + 31*t**4/144 - &
        !                                  t**3/18 - t**2/12
        t_terms(2, 1, 3)                = (t8/16.0) - ((41.0/120.0) * t7) + ((311.0/480.0) * t6) - ((71.0/240.0) * t5) - &
                                          ((173.0/288.0) * t4) + ((31.0/36.0) * t3) - (t2/SIX) - (t/SIX)
        !t_terms(2, 1, 4)                = -t**9/432 + t**8/80 - 5*t**7/224 + t**6/216 + t**5/30 - t**4/24
        t_terms(2, 1, 4)                = (-t8/48.0) + (t7/TEN) - ((FIVE/32.0) * t6) + (t5/36.0) + (t4/SIX) - (t3/SIX)
        !t_terms(2, 2, 1)                = -t**9/144 + 3*t**8/64 - 13*t**7/112 + 7*t**6/72 + t**5/12 - 5*t**4/24 + t**3/9
        t_terms(2, 2, 1)                = (-t8/16.0) + ((THREE/EIGHT) * t7) - ((13.0/16.0) * t6) + ((SEVEN/12.0) * t5) + &
                                          ((FIVE/12.0) * t4) - ((FIVE/SIX) * t3) + (t2/THREE)
        !t_terms(2, 2, 2)               = t**9/48 - t**8/8 + t**7/4 - t**6/12 - t**5/3 + t**4/3
        t_terms(2, 2, 2)                = ((THREE/16.0) * t8) - t7 + ((SEVEN/FOUR) * t6) - (t5/TWO) - ((FIVE/THREE) * t4) + &
                                          ((FOUR/THREE) * t3)
        !t_terms(2, 2, 3)               = -t**9/48 + 7*t**8/64 - 19*t**7/112 - t**6/24 + 19*t**5/60 - t**4/8 - t**3/9
        t_terms(2, 2, 3)                = (-(THREE/16.0) * t8) + ((SEVEN/EIGHT) * t7) - ((19.0/16.0) * t6) - (t5/FOUR) + &
                                          ((19.0/12.0) * t4) - (t3/TWO) - (t2/THREE)
        !t_terms(2, 2, 4)               = t**9/144 - t**8/32 + t**7/28 + t**6/36 - t**5/15
        t_terms(2, 2, 4)                = (t8/16.0) - (t7/FOUR) + (t6/FOUR) + (t5/SIX) - (t4/THREE)
        !t_terms(2, 3, 1)               = t**9/144 - 13*t**8/320 + 89*t**7/1120 - 11*t**6/480 - 11*t**5/96 + 5*t**4/48 +        &
        !                                 t**3/18 - t**2/12
        t_terms(2, 3, 1)                = (t8/16.0) - ((13.0/40.0) * t7) + ((89.0/160.0) * t6) - ((11.0/80.0) * t5) - &
                                          ((55.0/96.0) * t4) + ((FIVE/12.0) * t3) + (t2/SIX) - (t/SIX)
        !t_terms(2, 3, 2)               = -t**9/48 + 17*t**8/160 - 173*t**7/1120 - t**6/16 + 3*t**5/10 - t**4/24 - 2*t**3/9
        t_terms(2, 3, 2)                = (-(THREE/16.0) * t8) + ((17.0/20.0) * t7) - ((173.0/160.0) * t6) - &
                                          ((THREE/EIGHT) * t5) + ((THREE/TWO) * t4) - (t3/SIX) - ((TWO/THREE) * t2)
        !t_terms(2, 3, 3)               = t**9/48 - 29*t**8/320 + 99*t**7/1120 + 61*t**6/480 - 7*t**5/32 - 5*t**4/48 + t**3/6 + &
        !                                 t**2/12
        t_terms(2, 3, 3)                = ((THREE/16.0) * t8) - ((29.0/40.0) * t7) + ((99.0/160.0) * t6) + ((61.0/80.0)*t5) - &
                                          ((35.0/32.0) * t4) - ((FIVE/12.0) * t3) + (t2/TWO) + (t/SIX)
        !t_terms(2, 3, 4)               = -t**9/144 + t**8/40 - 3*t**7/224 - t**6/24 + t**5/30 + t**4/24
        t_terms(2, 3, 4)                = (-t8/16.0) + (t7/FIVE) - ((THREE/32.0) * t6) - (t5/FOUR) + (t4/SIX) + (t3/SIX)
        !t_terms(2, 4, 1)               = -t**9/432 + 11*t**8/960 - 29*t**7/1680 - t**6/1080 + t**5/45 - t**4/72
        t_terms(2, 4, 1)                = (-t8/48.0) + ((11.0/120.0) * t7) - ((29.0/240.0) * t6) - (t5/180.0) + (t4/NINE) - &
                                          (t3/18.0)
        !t_terms(2, 4, 2)               = t**9/144 - 7*t**8/240 + t**7/35 + t**6/36 - 2*t**5/45
        t_terms(2, 4, 2)                = (t8/16.0) - ((SEVEN/30.0) * t7) + (t6/FIVE) + (t5/SIX) - ((TWO/NINE) * t4)
        !t_terms(2, 4, 3)               = -t**9/144 + 23*t**8/960 - 19*t**7/1680 - 13*t**6/360 + t**5/45 + t**4/72
        t_terms(2, 4, 3)                = (-t8/16.0) + ((23.0/120.0) * t7) - ((19.0/240.0) * t6) - ((13.0/60.0) * t5) + &
                                          (t4/NINE) + (t3/18.0)
        !t_terms(2, 4, 4)               = t**9/432 - t**8/160 + t**6/108
        t_terms(2, 4, 4)                = (t8/48.0) - (t7/20.0) + (t5/18.0)

        !t_terms(3, 1, 1)               = -t**9/432 + 7*t**8/480 - t**7/30 + 31*t**6/1080 + t**5/360 - t**4/144 - t**3/48 + &
        !                                  t**2/48
        t_terms(3, 1, 1)                = (-t8/48.0) + ((SEVEN/60.0) * t7) - ((SEVEN/30.0) * t6) + ((31.0/180.0) * t5) + &
                                          (t4/72.0) - (t3/36.0) - (t2/16.0) + (t/24.0)
        !t_terms(3, 1, 2)               = t**9/144 - 37*t**8/960 + 39*t**7/560 - t**6/36 - 5*t**5/144 - t**4/96 + t**3/18
        t_terms(3, 1, 2)                = (t8/16.0) - ((37.0/120.0) * t7) + ((39.0/80.0) * t6) - (t5/SIX) - ((25.0/144.0)*t4) - &
                                          (t3/24.0) + (t2/SIX)
        !t_terms(3, 1, 3)               = -t**9/144 + t**8/30 - 19*t**7/420 - t**6/180 + 13*t**5/360 + t**4/36 - 5*t**3/144 - &
        !                                  t**2/48
        t_terms(3, 1, 3)                = (-t8/16.0) + ((FOUR/15.0) * t7) - ((19.0/60.0) * t6) - (t5/30.0) + &
                                          ((13.0/72.0) * t4) + (t3/NINE) - ((FIVE/48.0) * t2) - (t/24.0)
        !t_terms(3, 1, 4)               = t**9/432 - 3*t**8/320 + t**7/112 + t**6/216 - t**5/240 - t**4/96
        t_terms(3, 1, 4)                = (t8/48.0) - ((THREE/40.0) * t7) + (t6/16.0) + (t5/36.0) - (t4/48.0) - (t3/24.0)
        !t_terms(3, 2, 1)               = t**9/144 - 3*t**8/80 + 71*t**7/1120 - 3*t**6/160 - 13*t**5/480 - t**4/96 + t**3/36
        t_terms(3, 2, 1)                = (t8/16.0) - ((THREE/TEN) * t7) + ((71.0/160.0) * t6) - ((NINE/80.0) * t5) - &
                                          ((13.0/96.0) * t4) - (t3/24.0) + (t2/12.0)
        !t_terms(3, 2, 2)               = -t**9/48 + 31*t**8/320 - 127*t**7/1120 - t**6/24 + t**5/20 + t**4/12
        t_terms(3, 2, 2)                = (-(THREE/16.0) * t8) + ((31.0/40.0) * t7) - ((127.0/160.0) * t6) - (t5/FOUR) + &
                                          (t4/FOUR) + (t3/THREE)
        !t_terms(3, 2, 3)               = t**9/48 - 13*t**8/160 + 61*t**7/1120 + 13*t**6/160 - t**5/160 - 7*t**4/96 - t**3/36
        t_terms(3, 2, 3)                = ((THREE/16.0) * t8) - ((13.0/20.0) * t7) + ((61.0/160.0) * t6) + ((39.0/80.0)*t5) - &
                                          (t4/32.0) - ((SEVEN/24.0) * t3) - (t2/12.0)
        !t_terms(3, 2, 4)               = -t**9/144 + 7*t**8/320 - t**7/224 - t**6/48 - t**5/60
        t_terms(3, 2, 4)                = (-t8/16.0) + ((SEVEN/40.0) * t7) - (t6/32.0) - (t5/EIGHT) - (t4/12.0)
        !t_terms(3, 3, 1)               = -t**9/144 + t**8/32 - t**7/28 - t**6/72 + t**5/40 + t**4/48 - t**3/144 - t**2/48
        t_terms(3, 3, 1)                = (-t8/16.0) + (t7/FOUR) - (t6/FOUR) - (t5/12.0) + (t4/EIGHT) + (t3/12.0) - &
                                          (t2/48.0) - (t/24.0)
        !t_terms(3, 3, 2)               = t**9/48 - 5*t**8/64 + 5*t**7/112 + t**6/12 - t**5/240 - 7*t**4/96 - t**3/18
        t_terms(3, 3, 2)                = ((THREE/16.0) * t8) - ((FIVE/EIGHT) * t7) + ((FIVE/16.0) * t6) + (t5/TWO) - &
                                          (t4/48.0) - ((SEVEN/24.0) * t3) - (t2/SIX)
        !t_terms(3, 3, 3)               = -t**9/48 + t**8/16 - t**6/12 - t**5/24 + t**4/24 + t**3/16 + t**2/48
        t_terms(3, 3, 3)                = (-(THREE/16.0) * t8) + (t7/TWO) - (t5/TWO) - ((FIVE/24.0) * t4) + (t3/SIX) + &
                                          ((THREE/16.0) * t2) + (t/24.0)
        !t_terms(3, 3, 4)               = t**9/144 - t**8/64 - t**7/112 + t**6/72 + t**5/48 + t**4/96
        t_terms(3, 3, 4)                = (t8/16.0) - (t7/EIGHT) - (t6/16.0) + (t5/12.0) + ((FIVE/48.0) * t4) + (t3/24.0)
        !t_terms(3, 4, 1)               = t**9/432 - t**8/120 + 19*t**7/3360 + 17*t**6/4320 - t**5/1440 - t**4/288
        t_terms(3, 4, 1)                = (t8/48.0) - (t7/15.0) + ((19.0/480.0) * t6) + ((17.0/720.0) * t5) - (t4/288.0) - &
                                          (t3/72.0)
        !t_terms(3, 4, 2)               = -t**9/144 + 19*t**8/960 - t**7/1120 - t**6/72 - t**5/90
        t_terms(3, 4, 2)                = (-t8/16.0) + ((19.0/120.0) * t7) - (t6/160.0) - (t5/12.0) - (t4/18.0)
        !t_terms(3, 4, 3)               = t**9/144 - 7*t**8/480 - 31*t**7/3360 + 11*t**6/1440 + 17*t**5/1440 + t**4/288
        t_terms(3, 4, 3)                = (t8/16.0) - ((SEVEN/60.0) * t7) - ((31.0/480.0) * t6) + ((11.0/240.0) * t5) + &
                                          ((17.0/288.0) * t4) + (t3/72.0)
        !t_terms(3, 4, 4)               = -t**9/432 + t**8/320 + t**7/224 + t**6/432
        t_terms(3, 4, 4)                = (-t8/48.0) + (t7/40.0) + (t6/32.0) + (t5/72.0)

        !t_terms(4, 1, 1)               = t**9/1296 - 11*t**8/2880 + 73*t**7/10080 - t**6/160 + t**5/480
        t_terms(4, 1, 1)                = (t8/144.0) - ((11.0/360.0) * t7) + ((73.0/1440.0) * t6) - ((THREE/80.0) * t5) + &
                                          (t4/96.0)
        !t_terms(4, 1, 2)               = -t**9/432 + 7*t**8/720 - 47*t**7/3360 + t**6/144
        t_terms(4, 1, 2)                = (-t8/48.0) + ((SEVEN/90.0) * t7) - ((47.0/480.0) * t6) + (t5/24.0)
        !t_terms(4, 1, 3)               = t**9/432 - 23*t**8/2880 + 83*t**7/10080 - t**6/1440 - t**5/480
        t_terms(4, 1, 3)                = (t8/48.0) - ((23.0/360.0) * t7) + ((83.0/1440.0) * t6) - (t5/240.0) - (t4/96.0)
        !t_terms(4, 1, 4)               = -t**9/1296 + t**8/480 - t**7/672
        t_terms(4, 1, 4)                = (-t8/144.0) + (t7/60.0) - (t6/96.0)
        !t_terms(4, 2, 1)               = -t**9/432 + 3*t**8/320 - t**7/80 + t**6/180
        t_terms(4, 2, 1)                = (-t8/48.0) + ((THREE/40.0) * t7) - ((SEVEN/80.0) * t6) + (t5/30.0)
        !t_terms(4, 2, 2)               = t**9/144 - 11*t**8/480 + 2*t**7/105
        t_terms(4, 2, 2)                = (t8/16.0) - ((11.0/60.0) * t7) + ((TWO/15.0) * t6)
        !t_terms(4, 2, 3)               = -t**9/144 + 17*t**8/960 - 11*t**7/1680 - t**6/180
        t_terms(4, 2, 3)                = (-t8/16.0) + ((17.0/120.0) * t7) - ((11.0/240.0) * t6) - (t5/30.0)
        !t_terms(4, 2, 4)               = t**9/432 - t**8/240
        t_terms(4, 2, 4)                = (t8/48.0) - (t7/30.0)
        !t_terms(4, 3, 1)               = t**9/432 - 7*t**8/960 + t**7/160 + t**6/1440 - t**5/480
        t_terms(4, 3, 1)                = (t8/48.0) - ((SEVEN/120.0) * t7) + ((SEVEN/160.0) * t6) + (t5/240.0) - (t4/96.0)
        !t_terms(4, 3, 2)               = -t**9/144 + t**8/60 - 17*t**7/3360 - t**6/144
        t_terms(4, 3, 2)                = (-t8/16.0) + ((TWO/15.0) * t7) - ((17.0/480.0) * t6) - (t5/24.0)
        !t_terms(4, 3, 3)               = t**9/144 - 11*t**8/960 - 3*t**7/1120 + t**6/160 + t**5/480
        t_terms(4, 3, 3)                = (t8/16.0) - ((11.0/120.0) * t7) - ((THREE/160.0) * t6) + ((THREE/80.0)*t5) + (t4/96.0)
        !t_terms(4, 3, 4)               = -t**9/432 + t**8/480 + t**7/672
        t_terms(4, 3, 4)                = (-t8/48.0) + (t7/60.0) + (t6/96.0)
        !t_terms(4, 4, 1)               = -t**9/1296 + t**8/576 - t**7/1008
        t_terms(4, 4, 1)                = (-t8/144.0) + (t7/72.0) - (t6/144.0)
        !t_terms(4, 4, 2)               = t**9/432 - t**8/288
        t_terms(4, 4, 2)                = (t8/48.0) - (t7/36.0)
        !t_terms(4, 4, 3)               = -t**9/432 + t**8/576 + t**7/1008
        t_terms(4, 4, 3)                = (-t8/48.0) + (t7/72.0) + (t6/144.0)
        !t_terms(4, 4, 4)               = t**9/1296
        t_terms(4, 4, 4)                = (t8/144.0)


    end subroutine camber_t_terms_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute derivatives of the control points of
    ! a B-spline with respect to themselves and
    ! store them in an array. Includes the effect
    ! of ghost control points
    !
    ! Input parameters: ncp - number of control points
    !
    !-----------------------------------------------------------------------------------------------
    subroutine bspline_cp_ders (ncp, dcpall)

        integer,                intent(in)      :: ncp
        real,   allocatable,    intent(inout)   :: dcpall(:,:)

        ! Local variables
        integer                                 :: i


        !
        ! Allocate dcpall
        !
        if (allocated(dcpall)) deallocate(dcpall)
        allocate(dcpall(ncp, ncp + 2))


        !
        ! Compute derivatives
        !
        dcpall                          = 0.0

        ! Derivatives related to start point
        dcpall(1, 1)                    = 2.0
        dcpall(2, 1)                    = -1.0

        ! Derivatives realted to end point
        dcpall(ncp - 1, ncp + 2)        = -1.0
        dcpall(ncp, ncp + 2)            = 2.0

        ! Derivative of a control point wrt itself
        do i = 1, ncp
            dcpall(i, i + 1)            = 1.0
        end do


    end subroutine bspline_cp_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Function to compute the derivatives of spline
    ! parameter t wrt to a corresponding control
    ! point of the B-spline. This is used when a
    ! B-spline value is used to compute the associated
    ! value of t
    !
    ! Input parameters: t   - Spline parameter value
    !                   cp  - B-spline segment control points
    !                   A   - grouping of control points
    !                         (= -cp(0) + 3cp(1) - 3cp(2) + cp(3))
    !                   B   - grouping of control points
    !                         (= cp(0) - 6cp(1) + cp(2))
    !                   C   - grouping of control points
    !                         ( = -3(cp(0) - cp(2)))
    !                   k   - Index indicating the position of a
    !                         given control point in a given segment
    !                         of the B-spline - the index keeps track
    !                         of a particular B-spline control point
    !                         throughout the different segments
    !
    !-----------------------------------------------------------------------------------------------
    real function dt_cp (t, cp, A, B, C, print_from, k)

        real,                   intent(in)      :: t
        real,   optional,       intent(in)      :: cp(4)
        real,   optional,       intent(in)      :: A
        real,   optional,       intent(in)      :: B
        real,   optional,       intent(in)      :: C
        integer,    optional,   intent(in)      :: print_from
        integer,                intent(in)      :: k

        ! Local variables
        real                                    :: A_local, B_local, C_local, temp


        ! Temporary variables for grouping control points
        if (present(cp)) then

            ! Computed using control points
            A_local                     = -cp(1) + (THREE * cp(2)) - (THREE * cp(3)) + cp(4)
            B_local                     = (THREE * cp(1)) - (SIX * cp(2)) + (THREE * cp(3))
            C_local                     = -THREE * (cp(1) - cp(3))

        else

            ! Directly specified
            if (present(A)) A_local     = A
            if (present(B)) B_local     = B
            if (present(C)) C_local     = C

        end if

        temp                            = (THREE * A_local * (t**2)) + (TWO * B_local * t) + C_local


        ! Compute the derivative of t wrt to a control point
        select case (k)

            case (1)
                dt_cp                   = -(SIX * B0(t))/temp
            case (2)
                dt_cp                   = -(SIX * B1(t))/temp
            case (3)
                dt_cp                   = -(SIX * B2(t))/temp
            case (4)
                dt_cp                   = -(SIX * B3(t))/temp
            case default
                dt_cp                   = ZERO

        end select

    end function dt_cp
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivative of spline parameter
    ! t wrt to the first cubic B-spline control
    ! point for the 1st spline segment. This
    ! derivative differs from the normal derivative
    ! because of the ghost control point in the
    ! 1st segment
    !
    ! Input parameters: t   - Spline parameter value
    !                   cp  - B-spline segment control points
    !                   A   - grouping of control points
    !                         (= -cp(0) + 3cp(1) - 3cp(2) + cp(3))
    !                   B   - grouping of control points
    !                         (= cp(0) - 6cp(1) + cp(2))
    !                   C   - grouping of control points
    !                         ( = -3(cp(0) - cp(2)))
    !
    !-----------------------------------------------------------------------------------------------
    real function dt_cp01 (t, cp, A, B, C)

        real,                   intent(in)      :: t
        real,   optional,       intent(in)      :: cp(4)
        real,   optional,       intent(in)      :: A
        real,   optional,       intent(in)      :: B
        real,   optional,       intent(in)      :: C

        ! Local variables
        real                                    :: A_local, B_local, C_local


        ! Temporary variables for groupings of control points
        if (present(cp)) then

            ! Computed using control points
            A_local                     = -cp(1) + (THREE * cp(2)) - (THREE * cp(3)) + cp(4)
            B_local                     = (THREE * cp(1)) - (SIX * cp(2)) + (THREE * cp(3))
            C_local                     = -THREE * (cp(1) - cp(3))

        else

            ! Directly specified
            if (present(A)) A_local     = A
            if (present(B)) B_local     = B
            if (present(C)) C_local     = C


        end if


        ! Compute the derivative
        dt_cp01                         = -(t**3 - (SIX * t) + SIX)/((THREE * A_local * (t**2)) + &
                                          (TWO * B_local * t) + C_local)


    end function
    !-----------------------------------------------------------------------------------------------

    !
    ! Compute the derivative of spline parameter
    ! t wrt to the second cubic B-spline control
    ! point for the 1st spline segment. This
    ! derivative differs from the normal derivative
    ! because of the ghost control point in the
    ! 1st segment
    !
    ! Input parameters: t   - Spline parameter value
    !                   cp  - B-spline segment control points
    !                   A   - grouping of control points
    !                         (= -cp(0) + 3cp(1) - 3cp(2) + cp(3))
    !                   B   - grouping of control points
    !                         (= cp(0) - 6cp(1) + cp(2))
    !                   C   - grouping of control points
    !                         ( = -3(cp(0) - cp(2)))
    !
    !-----------------------------------------------------------------------------------------------
    real function dt_cp11 (t, cp, A, B, C)

        real,                   intent(in)      :: t
        real,   optional,       intent(in)      :: cp(4)
        real,   optional,       intent(in)      :: A
        real,   optional,       intent(in)      :: B
        real,   optional,       intent(in)      :: C

        ! Local variables
        real                                    :: A_local, B_local, C_local


        ! Temporary variables for groupings of control points
        if (present(cp)) then

            ! Computed using control points
            A_local                     = -cp(1) + (THREE * cp(2)) - (THREE * cp(3)) + cp(4)
            B_local                     = (THREE * cp(1)) - (SIX * cp(2)) + (THREE * cp(3))
            C_local                     = -THREE * (cp(1) - cp(3))

        else

            ! Directly specified
            if (present(A)) A_local     = A
            if (present(B)) B_local     = B
            if (present(C)) C_local     = C

        end if


        ! Compute the derivative
        dt_cp11                         = (TWO * t * (t**2 - THREE))/((THREE * A_local * (t**2)) + &
                                          (TWO * B_local * t) + C_local)


    end function
    !-----------------------------------------------------------------------------------------------

    !
    ! Compute the derivative of spline parameter
    ! t wrt to the (ncp - 1) cubic B-spline control
    ! point for the last spline segment. This
    ! derivative differs from the normal derivative
    ! because of the ghost control point in the
    ! last segment
    !
    ! Input parameters: t   - Spline parameter value
    !                   cp  - B-spline segment control points
    !                   A   - grouping of control points
    !                         (= -cp(0) + 3cp(1) - 3cp(2) + cp(3))
    !                   B   - grouping of control points
    !                         (= cp(0) - 6cp(1) + cp(2))
    !                   C   - grouping of control points
    !                         ( = -3(cp(0) - cp(2)))
    !
    !-----------------------------------------------------------------------------------------------
    real function dt_cp_ncp_1_last (t, cp, A, B, C)

        real,                   intent(in)      :: t
        real,   optional,       intent(in)      :: cp(4)
        real,   optional,       intent(in)      :: A
        real,   optional,       intent(in)      :: B
        real,   optional,       intent(in)      :: C

        ! Local variables
        real                                    :: A_local, B_local, C_local


        ! Temporary variables for groupings of control points
        if (present(cp)) then

            ! Computed using control points
            A_local                     = -cp(1) + (THREE * cp(2)) - (THREE * cp(3)) + cp(4)
            B_local                     = (THREE * cp(1)) - (SIX * cp(2)) + (THREE * cp(3))
            C_local                     = -THREE * (cp(1) - cp(3))

        else

            ! Directly specified
            if (present(A)) A_local     = A
            if (present(B)) B_local     = B
            if (present(C)) C_local     = C

        end if


        ! Compute the derivative
        dt_cp_ncp_1_last                = (-TWO * ((t - ONE)**2) * (t + TWO))/((THREE * A_local * (t**2)) + &
                                          (TWO * B_local * t) + C_local)


    end function
    !-----------------------------------------------------------------------------------------------

    !
    ! Compute the derivative of spline parameter
    ! t wrt to the (ncp - 1) cubic B-spline control
    ! point for the last spline segment. This
    ! derivative differs from the normal derivative
    ! because of the ghost control point in the
    ! last segment
    !
    ! Input parameters: t   - Spline parameter value
    !                   cp  - B-spline segment control points
    !                   A   - grouping of control points
    !                         (= -cp(0) + 3cp(1) - 3cp(2) + cp(3))
    !                   B   - grouping of control points
    !                         (= cp(0) - 6cp(1) + cp(2))
    !                   C   - grouping of control points
    !                         ( = -3(cp(0) - cp(2)))
    !
    !-----------------------------------------------------------------------------------------------
    real function dt_cp_ncp_last (t, cp, A, B, C)

        real,                   intent(in)      :: t
        real,   optional,       intent(in)      :: cp(4)
        real,   optional,       intent(in)      :: A
        real,   optional,       intent(in)      :: B
        real,   optional,       intent(in)      :: C

        ! Local variables
        real                                    :: A_local, B_local, C_local


        ! Temporary variables for groupings of control points
        if (present(cp)) then

            ! Computed using control points
            A_local                     = -cp(1) + (THREE * cp(2)) - (THREE * cp(3)) + cp(4)
            B_local                     = (THREE * cp(1)) - (SIX * cp(2)) + (THREE * cp(3))
            C_local                     = -THREE * (cp(1) - cp(3))

        else

            ! Directly specified
            if (present(A)) A_local     = A
            if (present(B)) B_local     = B
            if (present(C)) C_local     = C

        end if


        ! Compute the derivative
        dt_cp_ncp_last                  = (t**3 - (THREE * (t**2)) - (THREE * t) - ONE)/ &
                                          ((THREE * A_local * (t**2)) + (TWO * B_local * t) + C_local)


    end function
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivative of the B-spline parameter
    ! value wrt the value of the B-spline evaluated at
    ! that B-spline parameter
    !
    ! x = x_0 * B0(t) + x_1 * B1(t) + x_2 * B2(t) + x_3 * B3(t)
    !
    ! Compute dt/dx. This function is used to compute
    ! the sensitivity of t to u(i) when t is being
    ! computed using a Newton's method
    !
    ! Input parameters: t   - spline parameter value
    !                   cp  - B-spline control points
    !
    !-----------------------------------------------------------------------------------------------
    real function dt_dx (t, cp)

        real,                   intent(in)      :: t
        real,                   intent(in)      :: cp(4)

        ! Local variables
        real                                    :: A, B, C


        ! Groupings of control points
        A                               = -cp(1) + (THREE * cp(2)) - (THREE * cp(3)) + cp(4)
        B                               = (THREE * cp(1)) - (SIX * cp(2)) + (THREE * cp(3))
        C                               = -THREE * (cp(1) - cp(3))


        ! Compute derivative
        dt_dx                           = SIX/((THREE * A * (t**2)) + (TWO * B * t) + C)


    end function dt_dx
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the sensitivities of spanwise values of
    ! dependent variables wrt the control points of
    ! the spanwise cubic B-spline of the non-dimensional
    ! span
    !
    ! Input parameters: na              - number of spanwise sections
    !                   ncp             - number of control points of spanwise
    !                                     B-spline (includes 2 ghost points)
    !                   xcp             - control points of non-dimensional span
    !                   ycp             - control points of dependent variable
    !                   segment_info    - array containing indices of the control points
    !                                     comprising the B-spline segment in which a
    !                                     particular spanwise value lies
    !                   spline_params   - array containing the spline parameter value in
    !                                     the spline segment in which a particular spanwise
    !                                     value lies
    !
    !-----------------------------------------------------------------------------------------------
    subroutine compute_spanwise_xcp_ders (na, ncp, xcp, ycp, cp_pos, segment_info, spline_params, ders)

        integer,                intent(in)      :: na
        integer,                intent(in)      :: ncp
        real,                   intent(in)      :: xcp(ncp)
        real,                   intent(in)      :: ycp(ncp)
        integer,                intent(in)      :: cp_pos(na, ncp - 2)
        integer,                intent(in)      :: segment_info(na, 4)
        real,                   intent(in)      :: spline_params(na)
        real,                   intent(inout)   :: ders(na, ncp - 2)

        ! Local variables
        integer                                 :: i, j
        real                                    :: Ax(na), Bx(na), Cx(na), Ay(na), By(na), Cy(na), t


        !
        ! Grouping of control points for all spanwise
        ! locations - these terms will change for every
        ! B-spline segment
        !
        ! A = -cp_0 + 3cp_1 - 3cp_2 + cp_3
        ! B = 3cp_0 - 6cp_1 + 3cp_2
        ! C = -3(cp_0 - cp_2)
        !
        do i = 1, na

            ! For x control points
            Ax(i)                       = -xcp(segment_info(i, 1)) + (THREE * xcp(segment_info(i, 2))) - &
                                          (THREE * xcp(segment_info(i, 3))) + xcp(segment_info(i, 4))
            Bx(i)                       = (THREE * xcp(segment_info(i, 1))) - (SIX * xcp(segment_info(i, 2))) + &
                                          (THREE * xcp(segment_info(i, 3)))
            Cx(i)                       = -THREE * (xcp(segment_info(i, 1)) - xcp(segment_info(i, 3)))

            ! For y control points
            Ay(i)                       = -ycp(segment_info(i, 1)) + (THREE * ycp(segment_info(i, 2))) - &
                                          (THREE * ycp(segment_info(i, 3))) + ycp(segment_info(i, 4))
            By(i)                       = (THREE * ycp(segment_info(i, 1))) - (SIX * ycp(segment_info(i, 2))) + &
                                          (THREE * ycp(segment_info(i, 3)))
            Cy(i)                       = -THREE * (ycp(segment_info(i, 1)) - ycp(segment_info(i, 3)))

        end do



        !
        ! Compute sensitivities of the spline parameter
        ! t wrt to the control points of the control
        ! points of non-dimensional span
        !
        do i = 1, na

            ! Temporary variable
            t                           = spline_params(i)

            ! Loop through all control points of non-dimensional span
            do j = 1, ncp - 2

                !
                ! Sensitivity of t wrt to the 1st cp for
                ! segment 1 - accounts for ghost point
                !
                if (j == 1 .and. cp_pos(i, j) == 2) then

                    ders(i, j)          = dt_cp01 (t, A = Ax(i), B = Bx(i), C = Cx(i))

                !
                ! Sensitivity of t wrt to the 2nd cp for
                ! segment 1 - accounts for ghost point
                !
                else if (j == 2 .and. cp_pos(i, j) == 3) then

                    ders(i, j)          = dt_cp11 (t, A = Ax(i), B = Bx(i), C = Cx(i))

                !
                ! Sensitivity of t wrt to cp (ncp - 3) for
                ! the final segment - accounts for ghost point
                !
                else if (j == ncp - 3 .and. cp_pos(i, j) == 2) then

                    if (ncp - 3 /= 1) then
                        ders(i, j)      = dt_cp_ncp_1_last (t, A = Ax(i), B = Bx(i), C = Cx(i))
                    else
                        continue
                    end if

                !
                ! Sensitivity of t wrt to cp (ncp - 2) for
                ! the final segment - accounts for ghost point
                else if (j == ncp - 2 .and. cp_pos(i, j) == 3) then

                    if (ncp - 2 /= 2) then
                        ders(i, j)      = dt_cp_ncp_last (t, A = Ax(i), B = Bx(i), C = Cx(i))
                    else
                        continue
                    end if

                !
                ! Sensitivity of t wrt to the jth control point
                !
                else

                    ders(i, j)      = dt_cp (t, A = Ax(i), B = Bx(i), C = Cx(i), print_from = 0, k = cp_pos(i, j))

                end if

            end do  ! j = 1, ncp - 2

        end do  ! i = 1, na



        !
        ! Compute the sensitivity of spanwise dependent
        ! variable values wrt the control points of non-
        ! dimensional span. Computed as:
        !
        ! dy/dxcp = (dy/dt) * (dt/dxcp)
        !
        do i = 1, na

            t                           = spline_params(i)
            do j = 1, ncp - 2
                ders(i, j)              = (((THREE * Ay(i) * (t**2)) + (TWO * By(i) * t) + Cy(i))/SIX) * ders(i, j)
            end do

        end do  ! i = 1, na


    end subroutine compute_spanwise_xcp_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Subroutine to compute derivative of a spanwise
    ! B-spline value wrt to its control points
    !
    ! Input parameters: na              - number of spanwise sections
    !                   ncp             - number of spanwise B-spline control points
    !                                     including ghost points
    !                   segment_info    - array containing indices of the control points
    !                                     comprising the B-spline segment in which a
    !                                     particular spanwise value lies
    !                   dcpall          - array containing the derivatives of all control
    !                                     points wrt to themselves
    !                   spline_params   - array containing the spline parameter value in
    !                                     the spline segment in which a particular spanwise
    !                                     value lies
    !
    !-----------------------------------------------------------------------------------------------
    subroutine compute_spanwise_ycp_ders (na, ncp, segment_info, dcpall, spline_params, ders)

        integer,                intent(in)      :: na, ncp
        integer,                intent(in)      :: segment_info(na, 4)
        real,                   intent(in)      :: dcpall(ncp - 2, ncp), spline_params(na)
        real,                   intent(inout)   :: ders(na, ncp - 2)

        ! Local variables
        integer                                 :: i, j


        !
        ! Compute derivative of a spanwise value
        ! wrt to its control points
        !
        do i = 1, na
            do j = 1, ncp - 2
                ders(i, j)              = (dcpall(j, segment_info(i,1)) * B0(spline_params(i))) + &
                                          (dcpall(j, segment_info(i,2)) * B1(spline_params(i))) + &
                                          (dcpall(j, segment_info(i,3)) * B2(spline_params(i))) + &
                                          (dcpall(j, segment_info(i,4)) * B3(spline_params(i)))
            end do
        end do


    end subroutine compute_spanwise_ycp_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the sensitivity of the TE location, u_TE,
    ! with respect to NACA thickness parameters for a
    ! particular spanwise section
    !
    ! Input parameters: t_TE    - TE thickness
    !                   dt_TE   - TE thickness derivative
    !
    !-----------------------------------------------------------------------------------------------
    subroutine u_TE_derivatives (t_TE, dt_TE, du_TE)
        use globvar

        real,                   intent(in)      :: t_TE
        real,                   intent(in)      :: dt_TE
        real,                   intent(inout)   :: du_TE(5)


        !
        ! Compute derivatives of u_TE wrt to I, u_max, t_max
        ! t_TE and dt_TE
        !
        ! TODO: Only for explicit definition of TE thickness
        !       derivative
        !
        if (TE_der_actual) then

            du_TE(1)                    = 0
            du_TE(2)                    = 0
            du_TE(3)                    = 0
            du_TE(4)                    = -(dt_TE + sqrt((dt_TE)**2 + 1))
            du_TE(5)                    = -t_TE * (1 + (dt_TE/sqrt((dt_TE)**2 + 1)))

        end if


    end subroutine u_TE_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the sensitivity of the TE radius, r_TE,
    ! used in computation of the TE thickness circle with
    ! respect to NACA thickness parameters for a particular
    ! spanwise section
    !
    ! Input parameters: t_TE    - TE thickness
    !                   dt_TE   - TE thickness derivatives
    !
    !-----------------------------------------------------------------------------------------------
    subroutine r_TE_derivatives (t_TE, dt_TE, dr_TE)
        use globvar

        real,                   intent(in)      :: t_TE
        real,                   intent(in)      :: dt_TE
        real,                   intent(inout)   :: dr_TE(5)


        !
        ! Compute derivatives of r_TE wrt to I, u_max, t_max,
        ! t_TE and dt_TE
        !
        ! TODO: Only for explicit definition of TE thickness
        !       derivative
        !
        if (TE_der_actual) then

            dr_TE(1)                    = 0
            dr_TE(2)                    = 0
            dr_TE(3)                    = 0
            dr_TE(4)                    = sqrt((dt_TE)**2 + 1)
            dr_TE(5)                    = (t_TE * dt_TE)/sqrt((dt_TE)**2 + 1)

        end if


    end subroutine r_TE_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the sensitivity of the center of the TE thickness
    ! circle, u_center, with respect to NACA thickness parameters
    ! for a particular spanwise section
    !
    ! Input parameters: t_TE    - TE thickness
    !                   dt_TE   - TE thickness derivatives
    !
    !-----------------------------------------------------------------------------------------------
    subroutine u_center_derivatives (t_TE, dt_TE, duc_TE)
        use globvar

        real,                   intent(in)      :: t_TE
        real,                   intent(in)      :: dt_TE
        real,                   intent(inout)   :: duc_TE(5)


        !
        ! Compute derivatives of u_center wrt to I, u_max, t_max,
        ! t_TE and dt_TE
        !
        ! TODO: Only for explicit definition of TE thickness
        !       derivative
        !
        if (TE_der_actual) then

            duc_TE(1)                   = 0
            duc_TE(2)                   = 0
            duc_TE(3)                   = 0
            duc_TE(4)                   = -sqrt((dt_TE)**2 + 1)
            duc_TE(5)                   = -(t_TE * dt_TE)/sqrt((dt_TE)**2 + 1)

        end if


    end subroutine u_center_derivatives
    !-----------------------------------------------------------------------------------------------






    !-----------------------------------------------------------------------------------------------
    !
    ! The thickness coefficients d_i are computed as:
    !
    ! [d_0]   [M_00 M_01 M_02 M_03][t_max]
    ! [d_1] = [M_10 M_11 M_12 M_13][t_TE ]
    ! [d_2]   [M_20 M_21 M_22 M_23][0    ]
    ! [d_3]   [M_30 M_31 M_32 M_33][dt_TE]
    !
    ! The following subroutines compute and differentiate the
    ! elements of the matrix M wrt to the thickness parameters
    !
    ! These derivatives are then used to differentiate the d_i
    ! coefficients wrt the thickness parameters
    !
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the elements of the matrix M for a
    ! particular spanwise section
    !
    ! Input parameters: u_max   - location of the maximum thickness
    !                   u_TE    - location of the TE thickness
    !
    !-----------------------------------------------------------------------------------------------
    subroutine M_elements (u_max, u_TE, M)

        real,                   intent(in)      :: u_max
        real,                   intent(in)      :: u_TE
        real,                   intent(inout)   :: M(4, 4)

        ! Local variables
        real                                    :: temp_1, temp_2, temp_3


        ! Temporary variables
        temp_1                          = ONE - u_max
        temp_2                          = ONE - u_TE
        temp_3                          = u_TE - u_max

        ! Elements of M
        M(1, 1)                         = ((THREE * temp_1 * (temp_2**2)) - (temp_2**3))/(temp_3**3)
        M(1, 2)                         = ((temp_1**3) - (THREE * (temp_1**2) * temp_2))/(temp_3**3)
        M(1, 3)                         = (temp_1 * (temp_2**2))/(temp_3**2)
        M(1, 4)                         = ((temp_1**2) * temp_2)/(temp_3**2)

        M(2, 1)                         = -(SIX * temp_1 * temp_2)/(temp_3**3)
        M(2, 2)                         = (SIX * temp_1 * temp_2)/(temp_3**3)
        M(2, 3)                         = -((THREE - (TWO * u_max) - u_TE) * temp_2)/(temp_3**2)
        M(2, 4)                         = -(temp_1 * (THREE - u_max - (TWO * u_TE)))/(temp_3**2)

        M(3, 1)                         = (THREE * (TWO - u_max - u_TE))/(temp_3**3)
        M(3, 2)                         = -(THREE * (TWO - u_max - u_TE))/(temp_3**3)
        M(3, 3)                         = (THREE - u_max - (TWO * u_TE))/(temp_3**2)
        M(3, 4)                         = (THREE - (TWO * u_max) - u_TE)/(temp_3**2)

        M(4, 1)                         = -TWO/(temp_3**3)
        M(4, 2)                         = TWO/(temp_3**3)
        M(4, 3)                         = -ONE/(temp_3**2)
        M(4, 4)                         = -ONE/(temp_3**2)


    end subroutine M_elements
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of M wrt the NACA thickness
    ! parameters for a particular spanwise section
    !
    ! Input parameters: u_max   - location of the maximum thickness
    !                   u_TE    - location of the TE thickness
    !                   du_TE   - derivatives of u_TE
    !
    ! TODO: Only for explicit definition of TE thickness derivative
    !
    !-----------------------------------------------------------------------------------------------
    subroutine M_derivatives (u_max, u_TE, du_TE, dM)
        use globvar

        real,                   intent(in)      :: u_max
        real,                   intent(in)      :: u_TE
        real,                   intent(in)      :: du_TE(5)
        real,                   intent(inout)   :: dM(4, 4, 5)

        ! Local variables
        real                                    :: temp_1, temp_2, temp_3


        ! Temporary variables
        temp_1                          = ONE - u_max
        temp_2                          = ONE - u_TE
        temp_3                          = u_TE - u_max

        ! M_00 derivatives
        dM(1, 1, 1)                     = ZERO
        dM(1, 1, 2)                     = (SIX * temp_1 * (temp_2**2))/(temp_3**4)
        dM(1, 1, 3)                     = ZERO
        dM(1, 1, 4)                     = -((SIX * (temp_1**2) * temp_2)/(temp_3**4)) * du_TE(4)
        dM(1, 1, 5)                     = -((SIX * (temp_1**2) * temp_2)/(temp_3**4)) * du_TE(5)

        ! M_01 derivatives
        dM(1, 2, 1)                     = ZERO
        dM(1, 2, 2)                     = -(SIX * temp_1 * (temp_2**2))/(temp_3**4)
        dM(1, 2, 3)                     = ZERO
        dM(1, 2, 4)                     = ((SIX * (temp_1**2) * temp_2)/(temp_3**4)) * du_TE(4)
        dM(1, 2, 5)                     = ((SIX * (temp_1**2) * temp_2)/(temp_3**4)) * du_TE(5)

        ! M_02 derivatives
        dM(1, 3, 1)                     = ZERO
        dM(1, 3, 2)                     = ((TWO - u_max - u_TE) * (temp_2**2))/(temp_3**3)
        dM(1, 3, 3)                     = ZERO
        dM(1, 3, 4)                     = -((TWO * (temp_1**2) * temp_2)/(temp_3**3)) * du_TE(4)
        dM(1, 3, 5)                     = -((TWO * (temp_1**2) * temp_2)/(temp_3**3)) * du_TE(5)

        ! M_03 derivatives
        dM(1, 4, 1)                     = ZERO
        dM(1, 4, 2)                     = (TWO * temp_1 * (temp_2**2))/(temp_3**3)
        dM(1, 4, 3)                     = ZERO
        dM(1, 4, 4)                     = -(((TWO - u_max - u_TE) * (temp_1**2))/(temp_3**3)) * du_TE(4)
        dM(1, 4, 5)                     = -(((TWO - u_max - u_TE) * (temp_1**2))/(temp_3**3)) * du_TE(5)

        ! M_10 derivatives
        dM(2, 1, 1)                     = ZERO
        dM(2, 1, 2)                     = -(SIX * (THREE - (TWO * u_max) - u_TE) * temp_2)/(temp_3**4)
        dM(2, 1, 3)                     = ZERO
        dM(2, 1, 4)                     = ((SIX * (THREE - u_max - (TWO * u_TE)) * temp_1)/(temp_3**4)) * &
                                          du_TE(4)
        dM(2, 1, 5)                     = ((SIX * (THREE - u_max - (TWO * u_TE)) * temp_1)/(temp_3**4)) * &
                                          du_TE(5)

        ! M_11 derivatives
        dM(2, 2, 1)                     = ZERO
        dM(2, 2, 2)                     = (SIX * (THREE - (TWO * u_max) - u_TE) * temp_2)/(temp_3**4)
        dM(2, 2, 3)                     = ZERO
        dM(2, 2, 4)                     = -((SIX * (THREE - u_max - (TWO * u_TE)) * temp_1)/(temp_3**4)) * &
                                           du_TE(4)
        dM(2, 2, 5)                     = -((SIX * (THREE - u_max - (TWO * u_TE)) * temp_1)/(temp_3**4)) * &
                                           du_TE(5)

        ! M_12 derivatives
        dM(2, 3, 1)                     = ZERO
        dM(2, 3, 2)                     = -(TWO * (THREE - u_max - (TWO * u_TE) * temp_2))/(temp_3**3)
        dM(2, 3, 3)                     = ZERO
        dM(2, 3, 4)                     = ((TWO * (THREE - u_max - (TWO * u_TE) * temp_1))/(temp_3**3)) * &
                                          du_TE(4)
        dM(2, 3, 5)                     = ((TWO * (THREE - u_max - (TWO * u_TE) * temp_1))/(temp_3**3)) * &
                                          du_TE(5)

        ! M_13 derivatives
        dM(2, 4, 1)                     = ZERO
        dM(2, 4, 2)                     = -(TWO * (THREE - (TWO * u_max) - u_TE) * temp_2)/(temp_3**3)
        dM(2, 4, 3)                     = ZERO
        dM(2, 4, 4)                     = ((TWO * (THREE - (TWO * u_max) - u_TE) * temp_1)/(temp_3**3)) * &
                                          du_TE(4)
        dM(2, 4, 5)                     = ((TWO * (THREE - (TWO * u_max) - u_TE) * temp_1)/(temp_3**3)) * &
                                          du_TE(5)

        ! M_20 derivatives
        dM(3, 1, 1)                     = ZERO
        dM(3, 1, 2)                     = (SIX * (THREE - u_max - (TWO * u_TE)))/(temp_3**4)
        dM(3, 1, 3)                     = ZERO
        dM(3, 1, 4)                     = -((SIX * (THREE - (TWO * u_max) - u_TE))/(temp_3**4)) * du_TE(4)
        dM(3, 1, 5)                     = -((SIX * (THREE - (TWO * u_max) - u_TE))/(temp_3**4)) * du_TE(5)

        ! M_21 derivatives
        dM(3, 2, 1)                     = ZERO
        dM(3, 2, 2)                     = -(SIX * (THREE - u_max - (TWO * u_TE)))/(temp_3**4)
        dM(3, 2, 3)                     = ZERO
        dM(3, 2, 4)                     = ((SIX * (THREE - (TWO * u_max) - u_TE))/(temp_3**4)) * du_TE(4)
        dM(3, 2, 5)                     = ((SIX * (THREE - (TWO * u_max) - u_TE))/(temp_3**4)) * du_TE(5)

        ! M_22 derivatives
        dM(3, 3, 1)                     = ZERO
        dM(3, 3, 2)                     = (SIX - u_max - (FIVE * u_TE))/(temp_3**3)
        dM(3, 3, 3)                     = ZERO
        dM(3, 3, 4)                     = -((TWO * (THREE - (TWO * u_max) - u_TE))/(temp_3**3)) * du_TE(4)
        dM(3, 3, 5)                     = -((TWO * (THREE - (TWO * u_max) - u_TE))/(temp_3**3)) * du_TE(5)

        ! M_23 derivatives
        dM(3, 4, 1)                     = ZERO
        dM(3, 4, 2)                     = (TWO * (THREE - u_max - (TWO * u_TE)))/(temp_3**3)
        dM(3, 4, 3)                     = ZERO
        dM(3, 4, 4)                     = -((SIX - (FIVE * u_max) - u_TE)/(temp_3**3)) * du_TE(4)
        dM(3, 4, 5)                     = -((SIX - (FIVE * u_max) - u_TE)/(temp_3**3)) * du_TE(5)

        ! M_30 derivatives
        dM(4, 1, 1)                     = ZERO
        dM(4, 1, 2)                     = -SIX/(temp_3**4)
        dM(4, 1, 3)                     = ZERO
        dM(4, 1, 4)                     = (SIX/(temp_3**4)) * du_TE(4)
        dM(4, 1, 5)                     = (SIX/(temp_3**4)) * du_TE(5)

        ! M_31 derivatives
        dM(4, 2, 1)                     = ZERO
        dM(4, 2, 2)                     = SIX/(temp_3**4)
        dM(4, 2, 3)                     = ZERO
        dM(4, 2, 4)                     = -(SIX/(temp_3**4)) * du_TE(4)
        dM(4, 2, 5)                     = -(SIX/(temp_3**4)) * du_TE(5)

        ! M_32 derivatives
        dM(4, 3, 1)                     = ZERO
        dM(4, 3, 2)                     = -TWO/(temp_3**3)
        dM(4, 3, 3)                     = ZERO
        dM(4, 3, 4)                     = (TWO/(temp_3**3)) * du_TE(4)
        dM(4, 3, 5)                     = (TWO/(temp_3**3)) * du_TE(5)

        ! M_33 derivatives
        dM(4, 4, 1)                     = ZERO
        dM(4, 4, 2)                     = -TWO/(temp_3**3)
        dM(4, 4, 3)                     = ZERO
        dM(4, 4, 4)                     = (TWO/(temp_3**3)) * du_TE(4)
        dM(4, 4, 5)                     = (TWO/(temp_3**3)) * du_TE(5)


    end subroutine M_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the sensitivity of the thickness coefficients
    ! d_i for u_max =< u < u_TE for a particular spanwise
    ! section
    !
    ! Input parameters: u_max   - location of maximum thickness
    !                   u_TE    - location of TE thickness
    !                   du_TE   - derivatives of u_TE wrt thickness
    !                             parameters
    !                   t_max   - maximum thickness
    !                   t_TE    - TE thickness
    !                   dt_TE   - TE thickness derivative
    !
    !-----------------------------------------------------------------------------------------------
    subroutine d_derivatives (u_max, u_TE, du_TE, t_max, t_TE, dt_TE, dd)
        use globvar,    only: TE_der_actual

        real,                   intent(in)      :: u_max
        real,                   intent(in)      :: u_TE
        real,                   intent(in)      :: du_TE(5)
        real,                   intent(in)      :: t_max
        real,                   intent(in)      :: t_TE
        real,                   intent(in)      :: dt_TE
        real,                   intent(inout)   :: dd(4, 5)

        ! Local variables
        integer                                 :: i
        real                                    :: MM(4, 4), dMM(4, 4, 5)


        ! Initialize d_ders
        dd                              = 0.0



        !
        ! Compute sensitivities of d wrt thickness parameters
        ! TODO: Only for explicit specification of TE thickness
        !       derivative
        !
        if (TE_der_actual) then

            !
            ! Compute elements of matrix M as well as their
            ! sensitivities wrt thickness parameters
            !
            call M_elements (u_max, u_TE, MM)
            call M_derivatives (u_max, u_TE, du_TE, dMM)


            !
            ! Compute sensitivities of d_i wrt thickness
            ! parameters
            !
            do i = 1, 4
                dd(i, 1)                    = ZERO
                dd(i, 2)                    = (dMM(i, 1, 2) * t_max) + (dMM(i, 2, 2) * t_TE) + &
                                            (dMM(i, 4, 2) * dt_TE)
                dd(i, 3)                    = MM(i, 1)
                dd(i, 4)                    = (dMM(i, 1, 4) * t_max) + MM(i, 2) + (dMM(i, 2, 4) * &
                                            t_TE) + (dMM(i, 4, 4) * dt_TE)
                dd(i, 5)                    = (dMM(i, 1, 5) * t_max) + (dMM(i, 2, 5) * t_TE) + &
                                            MM(i, 4) + (dMM(i, 4, 5) * dt_TE)
            end do

        end if  ! TE_der_actual


    end subroutine d_derivatives
    !-----------------------------------------------------------------------------------------------






    !-----------------------------------------------------------------------------------------------
    !
    ! The thickness coefficients d_i are computed as:
    !
    ! a_0   = (\sqrt(2.2038)*I*t_max)/5
    ! [a_1]   [N_10 N_11 N_12][t_max - (a_0*sqrt(u_max))                       ]
    ! [a_2] = [N_20 N_21 N_22][-a_0/(2*sqrt(u_max))                            ]
    ! [a_3]   [N_30 N_31 N_32][2d_2 + 6d_3(1 - u_max) + (a_0/(4*sqrt(u_max^3)))]
    !
    ! The following subroutines compute and differentiate the
    ! elements of the matrix N wrt to the thickness parameters
    !
    ! These derivatives are then used to differentiate the a_i
    ! coefficients wrt the thickness parameters
    !
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute elements of matrix N for a particular spanwise
    ! section
    !
    ! Input parameters: u_max - location of maximum thickness
    !
    !-----------------------------------------------------------------------------------------------
    subroutine N_elements (u_max, N)

        real,                   intent(in)      :: u_max
        real,                   intent(inout)   :: N(3, 3)


        ! Compute elements of the matrix N
        N(1, 1)                         = THREE/u_max
        N(1, 2)                         = -TWO
        N(1, 3)                         = u_max/TWO

        N(2, 1)                         = -THREE/(u_max**2)
        N(2, 2)                         = THREE/u_max
        N(2, 3)                         = -ONE

        N(3, 1)                         = ONE/(u_max**3)
        N(3, 2)                         = -ONE/(u_max**2)
        N(3, 3)                         = ONE/(TWO * u_max)


    end subroutine N_elements
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute derivatives of the elements of the matrix
    ! N wrt the thickness parameters for a particular
    ! spanwise section
    !
    ! Input parameters: u_max - location of maximum thickness
    !
    !-----------------------------------------------------------------------------------------------
    subroutine N_derivatives (u_max, dN)

        real,                   intent(in)      :: u_max
        real,                   intent(inout)   :: dN(3, 3)


        !
        ! Compute sensitivities of the elements of the
        ! matrix N wrt thickness parameters (N elements
        ! only depend on u_max)
        !
        dN(1, 1)                        = -THREE/(u_max**2)
        dN(1, 2)                        = ZERO
        dN(1, 3)                        = ONE/TWO

        dN(2, 1)                        = SIX/(u_max**3)
        dN(2, 2)                        = -THREE/(u_max**2)
        dN(2, 3)                        = ZERO

        dN(3, 1)                        = -THREE/(u_max**4)
        dN(3, 2)                        = TWO/(u_max**3)
        dN(3, 3)                        = -ONE/(TWO * (u_max**2))


    end subroutine N_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute sensitivities of the coefficients of the a_i
    ! for 0 =< u < u_max for a particular spanwise section
    !
    ! Input parameters: LE_radius   - LE radius parameter
    !                   u_max       - location of maximum thickness
    !                   t_max       - maximum thickness
    !                   a_0         - first a coefficient
    !                   d_2         - third d coefficient
    !                   d_3         - fourth d coefficient
    !                   d_ders      - array containing sensitivities of
    !                                 the thickness coefficients d_i wrt
    !                                 thickness parameters
    !
    !-----------------------------------------------------------------------------------------------
    subroutine a_derivatives (LE_radius, u_max, t_max, a_0, d_2, d_3, d_ders, a_ders)
        use globvar,    only: TE_der_actual

        real,                   intent(in)      :: LE_radius
        real,                   intent(in)      :: u_max
        real,                   intent(in)      :: t_max
        real,                   intent(in)      :: a_0
        real,                   intent(in)      :: d_2
        real,                   intent(in)      :: d_3
        real,                   intent(in)      :: d_ders(4, 5)
        real,                   intent(inout)   :: a_ders(4, 5)

        ! Local variables
        integer                                 :: i
        real                                    :: NN(3, 3), dNN(3, 3)


        ! Initialize a_ders
        a_ders                          = 0.0



        !
        ! Compute sensitivities of a wrt thickness parameters
        ! TODO: Only for explicit specification of TE thickness
        !       derivative
        !
        if (TE_der_actual) then

            !
            ! Compute elements of matrix N and their
            ! corresponding derivatives
            !
            call N_elements (u_max, NN)
            call N_derivatives (u_max, dNN)


            ! Sensitivities of a_0
            a_ders(1, 1)                    = (sqrt(2.2038) * t_max)/THREE
            a_ders(1, 2)                    = ZERO
            a_ders(1, 3)                    = (sqrt(2.2038) * LE_radius)/THREE
            a_ders(1, 4)                    = ZERO
            a_ders(1, 5)                    = ZERO

            ! Sensitivities of a_1, a_2 and a_3
            do i = 1, 3
                a_ders(i + 1, 1)            = -((NN(i, 1) * sqrt(u_max)) + (NN(i, 2)/(TWO * sqrt(u_max))) - &
                                                (NN(i, 3)/(FOUR * sqrt(u_max**3)))) * a_ders(1, 1)
                a_ders(i + 1, 2)            = (dNN(i, 1) * (t_max - (a_0 * sqrt(u_max)))) - ((NN(i, 1) + &
                                            dNN(i,2)) * (a_0/(TWO * sqrt(u_max)))) + ((NN(i, 2) + &
                                            dNN(i, 3)) * (a_0/(FOUR * sqrt(u_max**3)))) + (dNN(i, 3) * &
                                            ((TWO * d_2) + (SIX * d_3 * (ONE - u_max)))) + (NN(i, 3) * &
                                            ((TWO * d_ders(3, 2)) + (SIX * d_ders(4, 2) * (ONE - u_max)) - &
                                            (SIX * d_3) - ((THREE * a_0)/(EIGHT * sqrt(u_max**5)))))
                a_ders(i + 1, 3)            = NN(i, 1) + (NN(i, 3) * ((TWO * d_ders(3, 3)) + (SIX * (ONE - &
                                            u_max) * d_ders(4, 3)))) - (((NN(i, 1) * sqrt(u_max)) + &
                                            (NN(i, 2)/(TWO * sqrt(u_max))) - (NN(i, 3)/(FOUR * &
                                            sqrt(u_max**3)))) * a_ders(1, 3))
                a_ders(i + 1, 4)            = NN(i, 3) * ((TWO * d_ders(3, 4)) + (SIX * (ONE - u_max) * &
                                            d_ders(4, 4)))
                a_ders(i + 1, 5)            = NN(i, 3) * ((TWO * d_ders(3, 5)) + (SIX * (ONE - u_max) * &
                                            d_ders(4, 5)))
            end do

        end if  ! TE_der_actual


    end subroutine a_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of u wrt thickness parameters
    ! This is only necessary for ellipse-based clustering
    !
    !-----------------------------------------------------------------------------------------------
    subroutine u_derivatives (np, np_cluster, LE_radius, t_max, duTE_t_TE, duTE_dt_TE, u_ders)
        use globvar, only: TE_der_actual, du_ell_LE, du_hyp_LE, du_hyp_TE, du_ell_TE

        integer,                intent(in)      :: np
        integer,                intent(in)      :: np_cluster
        real,                   intent(in)      :: LE_radius
        real,                   intent(in)      :: t_max
        real,                   intent(in)      :: duTE_t_TE
        real,                   intent(in)      :: duTE_dt_TE
        real,                   intent(inout)   :: u_ders(np, 5)

        ! Local variables
        integer                                 :: i, np_mid, np_mid_LE, np_mid_TE
        real                                    :: duLE_I, duLE_t_max


        ! Compute value of n_mid
        np_mid                          = np - (2 * np_cluster) + 2
        np_mid_LE                       = (np_mid - 1)/2
        np_mid_TE                       = ((np_mid - 1)/2) - 1



        ! Sensitivities of u_LE wrt I and t_max
        duLE_I                          = (2.2038/NINE) * LE_radius * (t_max**2)
        duLE_t_max                      = (2.2038/NINE) * (LE_radius**2) * t_max



        !
        ! Compute sensitivities of u wrt thickness parameters
        ! TODO: Only for specification of TE thickness derivative
        !
        if (TE_der_actual) then

            ! For 0 <= u <= u_LE
            do i = 1, np_cluster
                u_ders(i, 1)                = duLE_I * du_ell_LE(i, 1)
                u_ders(i, 2)                = 0.0
                u_ders(i, 3)                = (duLE_t_max * du_ell_LE(i, 3))/TWO
                u_ders(i, 4)                = 0.0
                u_ders(i, 5)                = 0.0
            end do

            ! For u_LE < u <= u_mid
            do i = np_cluster + 1, np_cluster + np_mid_LE
                u_ders(i, 1)                = 0.5 * duLE_I * du_hyp_LE(i, 1)
                u_ders(i, 2)                = 0.0
                u_ders(i, 3)                = (0.5 * duLE_t_max * du_hyp_LE(i, 3))/TWO
                u_ders(i, 4)                = (0.5 * duTE_t_TE * du_hyp_LE(i, 4))/TWO
                u_ders(i, 5)                = 0.5 * duTE_dt_TE * du_hyp_LE(i, 5)
            end do

            ! For u_mid < u < u_TE
            do i = np_cluster + np_mid_LE + 1, np_cluster + np_mid_LE + np_mid_TE
                u_ders(i, 1)                = 0.5 * duLE_I * du_hyp_TE(i, 1)
                u_ders(i, 2)                = 0.0
                u_ders(i, 3)                = (0.5 * duLE_t_max * du_hyp_TE(i, 3))/TWO
                u_ders(i, 4)                = (0.5 * duTE_t_TE * du_hyp_TE(i, 4))/TWO
                u_ders(i, 5)                = 0.5 * duTE_dt_TE * du_hyp_TE(i, 5)
            end do

            ! For u_TE <= u <= 1
            do i = np - np_cluster + 1,np
                u_ders(i, 1)                = 0.0
                u_ders(i, 2)                = 0.0
                u_ders(i, 3)                = 0.0
                u_ders(i, 4)                = (duTE_t_TE * du_ell_TE(i, 4))/TWO
                u_ders(i, 5)                = duTE_dt_TE * du_ell_TE(i, 5)
            end do

        end if


    end subroutine u_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the sensitivity of the NACA thickness distribution
    ! wrt the thickness parameters
    !
    ! Input parameters: np          - number of points of u
    !                   np_cluster  - number of points for LE and TE clustering
    !                   thk_cp      - thickness distribution parameters in the order:
    !                                 I_LE, u_max, t_max, t_TE, t'_TE
    !                   u_TE        - location of the TE thickness
    !                   a_NACA      - NACA thickness coefficients for u < u_max
    !                   d_NACA      - NACA thickness coefficients for u >= u_max
    !
    !-----------------------------------------------------------------------------------------------
    subroutine NACA_thickness_derivatives (js, np, np_cluster, u, thk, thk_cp, u_TE, uc, r_TE, &
                                           a_NACA, d_NACA, u_ders, NACA_ders)
        use globvar,    only: TE_der_actual, clustering_switch

        integer,                intent(in)      :: js
        integer,                intent(in)      :: np
        integer,                intent(in)      :: np_cluster
        real,                   intent(in)      :: u(np)
        real,                   intent(in)      :: thk(np)
        real,                   intent(in)      :: thk_cp(5)
        real,                   intent(in)      :: u_TE
        real,                   intent(in)      :: uc
        real,                   intent(in)      :: r_TE
        real,                   intent(in)      :: a_NACA(4)
        real,                   intent(in)      :: d_NACA(4)
        real,                   intent(inout)   :: u_ders(np, 5)
        real,                   intent(inout)   :: NACA_ders(np, 5)

        ! Local variables
        integer                                 :: i
        real,   parameter                       :: tol = 10E-8
        real                                    :: du_TE(5), dr_TE(5), duc(5), d_ders(4, 5), &
                                                   a_ders(4, 5)


        ! Initialize output arrays
        NACA_ders                       = 0.0
        u_ders                          = 0.0


        !
        ! Compute derivatives of u_TE, r_TE and u_center
        ! wrt the thickness parameters
        !
        call u_TE_derivatives (thk_cp(4), thk_cp(5), du_TE)
        call r_TE_derivatives (thk_cp(4), thk_cp(5), dr_TE)
        call u_center_derivatives (thk_cp(4), thk_cp(5), duc)


        !
        ! Compute sensitivities of thickness coefficients
        ! wrt the thickness distribution parameters
        !
        call d_derivatives (thk_cp(2), u_TE, du_TE, thk_cp(3), thk_cp(4), thk_cp(5), d_ders)
        call a_derivatives (thk_cp(1), thk_cp(2), thk_cp(3), a_NACA(1), d_NACA(3), d_NACA(4), d_ders, a_ders)


        ! Compute derivatives of u wrt the thickness parameters
        ! for ellipse-based clustering
        if (clustering_switch == 4) &
             call u_derivatives (np, np_cluster, thk_cp(1), thk_cp(3), du_TE(4), du_TE(5), u_ders)


        !
        ! TODO: Derivatives available only for explicit specification
        !       of the TE thickness derivative
        !
        if (TE_der_actual) then

            ! Thickness derivatives for clustering methods
            ! other than the ellipse-based one
            if (clustering_switch /= 4) then

                do i = 1, np

                    ! u < u_max
                    if (u(i) < thk_cp(2)) then

                        NACA_ders(i, 1)     = (a_ders(1, 1) * sqrt(u(i))) + (a_ders(2, 1) * u(i)) + &
                                              (a_ders(3, 1) * (u(i)**2)) + (a_ders(4, 1) * (u(i)**3))
                        NACA_ders(i, 2)     = (a_ders(1, 2) * sqrt(u(i))) + (a_ders(2, 2) * u(i)) + &
                                              (a_ders(3, 2) * (u(i)**2)) + (a_ders(4, 2) * (u(i)**3))
                        NACA_ders(i, 3)     = (a_ders(1, 3) * sqrt(u(i))) + (a_ders(2, 3) * u(i)) + &
                                              (a_ders(3, 3) * (u(i)**2)) + (a_ders(4, 3) * (u(i)**3))
                        NACA_ders(i, 4)     = (a_ders(1, 4) * sqrt(u(i))) + (a_ders(2, 4) * u(i)) + &
                                              (a_ders(3, 4) * (u(i)**2)) + (a_ders(4, 4) * (u(i)**3))
                        NACA_ders(i, 5)     = (a_ders(1, 5) * sqrt(u(i))) + (a_ders(2, 5) * u(i)) + &
                                              (a_ders(3, 5) * (u(i)**2)) + (a_ders(4, 5) * (u(i)**3))
                    ! u >= u_max
                    else if ((abs(u(i) - thk_cp(2)) < tol) .or. (u(i) > thk_cp(2))) then

                        ! u_max <= u < u_TE
                        if (u(i) < u_TE) then

                            NACA_ders(i, 1) = 0.0
                            NACA_ders(i, 2) = d_ders(1, 2) + (d_ders(2, 2) * (ONE - u(i))) + &
                                              (d_ders(3, 2) * ((ONE - u(i))**2)) + (d_ders(4, 2) * ((ONE - u(i))**3))
                            NACA_ders(i, 3) = d_ders(1, 3) + (d_ders(2, 3) * (ONE - u(i))) + &
                                              (d_ders(3, 3) * ((ONE - u(i))**2)) + (d_ders(4, 3) * ((ONE - u(i))**3))
                            NACA_ders(i, 4) = d_ders(1, 4) + (d_ders(2, 4) * (ONE - u(i))) + &
                                              (d_ders(3, 4) * ((ONE - u(i))**2)) + (d_ders(4, 4) * ((ONE - u(i))**3))
                            NACA_ders(i, 5) = d_ders(1, 5) + (d_ders(2, 5) * (ONE - u(i))) + &
                                              (d_ders(3, 5) * ((ONE - u(i))**2)) + (d_ders(4, 5) * ((ONE - u(i))**3))

                        ! u >= u_TE
                        else

                            if (abs(ONE - u(i)) > tol) then
                                NACA_ders(i, 4) &
                                            = (ONE/thk(i)) * ((r_TE * dr_TE(4)) + ((u(i) - uc) * duc(4)))
                                NACA_ders(i, 5) &
                                            = (ONE/thk(i)) * ((r_TE * dr_TE(5)) + ((u(i) - uc) * duc(5)))
                            end if

                        end if  ! u(i) < u_TE

                    end if  ! u(i)

                end do  ! i = 1, np

            else    ! for ellipse-based clustering

                do i = 1, np

                    ! u < u_max
                    if (u(i) < thk_cp(2)) then

                        ! 0 < u < u_max
                        if (u(i) > tol) then

                            NACA_ders(i, 1) = ((a_ders(1, 1) * sqrt(u(i))) + (a_ders(2, 1) * u(i)) +    &
                                              (a_ders(3, 1) * (u(i)**2)) + (a_ders(4, 1) * (u(i)**3)) + &
                                              (((a_NACA(1)/(TWO * sqrt(u(i)))) + a_NACA(2) + (TWO *     &
                                              a_NACA(3) * u(i)) + (THREE * a_NACA(4) * (u(i)**2))) *    &
                                              u_ders(i, 1))) * TWO
                            NACA_ders(i, 2) = ((a_ders(1, 2) * sqrt(u(i))) + (a_ders(2, 2) * u(i)) +    &
                                              (a_ders(3, 2) * (u(i)**2)) + (a_ders(4, 2) * (u(i)**3))) * TWO
                            NACA_ders(i, 3) = (a_ders(1, 3) * sqrt(u(i))) + (a_ders(2, 3) * u(i)) +     &
                                              (a_ders(3, 3) * (u(i)**2)) + (a_ders(4, 3) * (u(i)**3)) + &
                                              (((a_NACA(1)/(TWO * sqrt(u(i)))) + a_NACA(2) + (TWO *     &
                                              a_NACA(3) * u(i)) + (THREE * a_NACA(4) * (u(i)**2))) *    &
                                              (TWO * u_ders(i, 3)))
                            NACA_ders(i, 4) = (a_ders(1, 4) * sqrt(u(i))) + (a_ders(2, 4) * u(i)) +     &
                                              (a_ders(3, 4) * (u(i)**2)) + (a_ders(4, 4) * (u(i)**3)) + &
                                              (((a_NACA(1)/(TWO * sqrt(u(i)))) + a_NACA(2) + (TWO *     &
                                              a_NACA(3) * u(i)) + (THREE * a_NACA(4) * (u(i)**2))) *    &
                                              (TWO * u_ders(i, 4)))
                            NACA_ders(i, 5) = ((a_ders(1, 5) * sqrt(u(i))) + (a_ders(2, 5) * u(i)) +    &
                                              (a_ders(3, 5) * (u(i)**2)) + (a_ders(4, 5) * (u(i)**3)) + &
                                              (((a_NACA(1)/(TWO * sqrt(u(i)))) + a_NACA(2) + (TWO *     &
                                              a_NACA(3) * u(i)) + (THREE * a_NACA(4) * (u(i)**2))) *    &
                                              u_ders(i, 5))) * TWO
                        end if

                    ! u >= u_max
                    else if ((abs(u(i) - thk_cp(2)) < tol) .or. (u(i) > thk_cp(2))) then

                        ! u_max <= u < u_TE
                        if (u(i) < u_TE) then

                            NACA_ders(i, 1) = (-(d_NACA(2) + (TWO * d_NACA(3) * (ONE - u(i))) + (THREE * d_NACA(4) *    &
                                              ((ONE - u(i))**2))) * u_ders(i, 1)) * TWO
                            NACA_ders(i, 2) = (d_ders(1, 2) + (d_ders(2, 2) * (ONE - u(i))) + &
                                              (d_ders(3, 2) * ((ONE - u(i))**2)) + (d_ders(4, 2) * ((ONE - u(i))**3))) * TWO
                            NACA_ders(i, 3) = d_ders(1, 3) + (d_ders(2, 3) * (ONE - u(i))) + &
                                              (d_ders(3, 3) * ((ONE - u(i))**2)) + (d_ders(4, 3) * ((ONE - u(i))**3)) - &
                                              ((d_NACA(2) + (TWO * d_NACA(3) * (ONE - u(i))) + (THREE * d_NACA(4) *     &
                                              ((ONE - u(i))**2))) * (TWO * u_ders(i, 3)))
                            NACA_ders(i, 4) = d_ders(1, 4) + (d_ders(2, 4) * (ONE - u(i))) + &
                                              (d_ders(3, 4) * ((ONE - u(i))**2)) + (d_ders(4, 4) * ((ONE - u(i))**3)) - &
                                              ((d_NACA(2) + (TWO * d_NACA(3) * (ONE - u(i))) + (THREE * d_NACA(4) *     &
                                              ((ONE - u(i))**2))) * (TWO * u_ders(i, 4)))
                            NACA_ders(i, 5) = (d_ders(1, 5) + (d_ders(2, 5) * (ONE - u(i))) + &
                                              (d_ders(3, 5) * ((ONE - u(i))**2)) + (d_ders(4, 5) * ((ONE - u(i))**3)) - &
                                              ((d_NACA(2) + (TWO * d_NACA(3) * (ONE - u(i))) + (THREE * d_NACA(4) *     &
                                              ((ONE - u(i))**2))) * u_ders(i, 5))) * TWO

                        ! u_TE <= u < 1
                        else

                            if (abs(ONE - u(i)) > tol) then

                                NACA_ders(i, 4) &
                                            = (ONE/thk(i)) * ((r_TE * dr_TE(4)) - ((u(i) - uc) * &
                                              ((TWO * u_ders(i, 4)) - duc(4))))
                                NACA_ders(i, 5) &
                                            = ((ONE/thk(i)) * ((r_TE * dr_TE(5)) - ((u(i) - uc) * &
                                              (u_ders(i, 5) - duc(5))))) * TWO
                            end if

                        end if  ! u(i) < u_TE

                    end if  ! u(i)

                end do  ! do i = 1, np

            end if  ! clustering_switch

        end if  ! TE_der_actual

        !if (clustering_switch == 4) then
        !    if (js == 21) then
        !        do i = 1, np
        !            print *, NACA_ders(i, 3)
        !        end do
        !    end if
        !end if


    end subroutine NACA_thickness_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Use chain rule to compute the derivatives of the
    ! mean-line and the mean-line first derivative wrt
    ! the NACA thickness parameters using the derivatives
    ! wrt u when using ellipse-based clustering
    !
    ! Input parameters: dslope_du   - derivative of mean-line first
    !                                 derivative wrt u
    !                   dcam_du     - derivative of mean-line wrt u
    !                   u_ders      - derivatives of u wrt thickness
    !                                 parameters
    !
    ! dslope_du and dcam_du are computed in bsplinecam.f90
    !
    !-----------------------------------------------------------------------------------------------
    subroutine meanline_thickness_derivatives (dslope_du, dcam_du, u_ders, slope_ders, cam_ders)

        real,                   intent(in)      :: dslope_du(:)
        real,                   intent(in)      :: dcam_du(:)
        real,                   intent(in)      :: u_ders(:,:)
        real,                   intent(inout)   :: slope_ders(:,:)
        real,                   intent(inout)   :: cam_ders(:,:)

        ! Local variables
        integer                                 :: np, i, j


        ! Number of points along blade section
        np                              = size(dslope_du)


        ! Compute derivatives
        do i = 1, np
            do j = 1, 5
                slope_ders(i, j)        = dslope_du(i) * u_ders(i, j)
                cam_ders(i, j)          = dcam_du(i) * u_ders(i, j)
            end do
        end do


    end subroutine meanline_thickness_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the sensitivities of the quantity angle
    ! with respect to u. This is done when using
    ! ellipse-based clustering
    !
    ! Input parameters: j   - B-spline segment index
    !                   t   - B-spline parameter value
    !                   k   - scaling factor
    !                   xcp - control points of u
    !                   ycp - control points of v''_m(u)
    !
    !-----------------------------------------------------------------------------------------------
    subroutine angle_u_ders (j, t, k, xcp, ycp, dslope_du)

        integer,                intent(in)      :: j
        real,                   intent(in)      :: t
        real,                   intent(in)      :: k
        real,                   intent(in)      :: xcp(:)
        real,                   intent(in)      :: ycp(:)
        real,                   intent(inout)   :: dslope_du

        ! Local variables
        integer                                 :: l, m
        real                                    :: dt_terms(4, 4), sum1, sum2


        !
        ! Compute the derivatives of the functions
        ! of t used to compute angle with respect to t
        !
        call angle_t_terms_ders (t, dt_terms)


        !
        ! Differentiate angle with respect to t
        !
        sum1                            = 0.0
        do m = 1, 4
            sum2                        = 0.0
            do l = 1, 4
                sum2                    = sum2 + (xcp(j + l - 1) * dt_terms(m, l))
            end do
            sum1                        = sum1 + (ycp(j + m - 1) * sum2)
        end do


        !
        ! Differentiate angle with respect to u
        ! dt_dx computes the sensitivity of t wrt u
        !
        dslope_du                       = -k * sum1 * dt_dx(t, xcp(j:j + 3))


    end subroutine angle_u_ders
    !-----------------------------------------------------------------------------------------------






    !
    !
    !
    !-----------------------------------------------------------------------------------------------
    subroutine camber_u_ders (j, t, k, xcp, ycp, angle0, camber, dcam_du)

        integer,                intent(in)      :: j
        real,                   intent(in)      :: t
        real,                   intent(in)      :: k
        real,                   intent(in)      :: xcp(:)
        real,                   intent(in)      :: ycp(:)
        real,                   intent(in)      :: angle0
        real,                   intent(in)      :: camber
        real,                   intent(inout)   :: dcam_du

        ! Local variables
        integer                                 :: l, m, n
        real                                    :: dt_terms(4, 4, 4), sum1, sum2, sum3, xterm


        !
        ! Compute the derivatives of the functions
        ! of t used to compute camber with respect to t
        !
        call camber_t_terms_ders (t, dt_terms)


        !
        ! Differentiate camber with respect to t
        !
        sum1                            = 0.0
        do n = 1, 4
            sum2                        = 0.0
            do m = 1, 4
                sum3                    = 0.0
                do l = 1, 4
                    sum3                = sum3 + (xcp(j + l - 1) * dt_terms(n, m, l))
                end do
                sum2                    = sum2 + (xcp(j + m - 1) * sum3)
            end do
            sum1                        = sum1 + (ycp(j + n - 1) * sum2)
        end do

        xterm                           = (xcp(j) * (-(t**2/TWO) + t - 0.5)) + (xcp(j + 1) * ((1.5 * (t**2)) -    &
                                          (TWO * t))) + (xcp(j + 2) * ((-1.5 * (t**2)) + t + 0.5)) + (xcp(j + 3) * &
                                          (t**2/TWO))

        dcam_du                         = k * (((-sum1 + (angle0 * xterm)) * dt_dx(t, xcp(j:j + 3))) - camber)


    end subroutine camber_u_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute derivatives of u_end with respect to
    ! all control points of u. u_end contains the
    ! values of u(t) marking the ends of B-spline
    ! segments and are computed as:
    !
    ! u_end(j + 1) = u(j)B_0(t) + u(j + 1)B_1(t) + u(j + 2)B_2(t) +
    !                u(j + 3)B_3(t)
    !
    ! Input parameters: j       - B-spline segment index
    !                   dcpall  - array containing derivatives of the
    !                             B-spline control points wrt themselves
    !                   t       - B-spline parameter value
    !
    !-----------------------------------------------------------------------------------------------
    subroutine u_end_xcp_ders (j, dcpall, t, ders)

        integer,                intent(in)      :: j
        real,                   intent(in)      :: dcpall(:,:)
        real,                   intent(in)      :: t
        real,                   intent(inout)   :: ders(:)

        ! Local variables
        integer                                 :: ncp, i


        ! Number of control points
        ncp                             = size(dcpall, 1)


        ! Compute derivatives
        do i = 1, ncp
            ders(i)                     = (dcpall(i, j) * B0(t)) + (dcpall(i, j + 1) * B1(t)) + &
                                          (dcpall(i, j + 2) * B2(t)) + (dcpall(i, j + 3) * B3(t))
        end do


    end subroutine u_end_xcp_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of the integral of v''_m(u)
    ! wrt the control points of u. This quantity is
    ! computed in the function angle defined in bsplinecam.f90
    !
    ! Input parameters: j       - segment index for the B-spline of
    !                             v''_m(u)
    !                   dcpall  - array containing the derivatives of
    !                             the control points wrt themselves
    !                   ycp     - control points of v''_m(u)
    !                   t       - spline parameter value
    !
    !-----------------------------------------------------------------------------------------------
    subroutine angle_xcp_ders (js, j, dcpall, xcp, ycp, t, newton, ders)

        integer,                intent(in)      :: js
        integer,                intent(in)      :: j
        real,                   intent(in)      :: dcpall(:,:)
        real,                   intent(in)      :: xcp(:)
        real,                   intent(in)      :: ycp(:)
        real,                   intent(in)      :: t
        logical,                intent(in)      :: newton
        real,   allocatable,    intent(inout)   :: ders(:)

        ! Local variables
        integer                                 :: ncp, i, l, m
        integer,    allocatable                 :: cp_pos(:)
        real                                    :: sum1, sum2, t_terms(4, 4), dt_terms(4, 4)
        real,       allocatable                 :: dt_dxcp(:)


        ! Number of control points
        ncp                             = size(dcpall, 1)

        ! Allocate and initialize result array
        if (allocated(ders)) deallocate(ders)
        allocate(ders(ncp))

        ders                            = 0.0



        !
        ! Groupings of spline parameter t used
        ! to compute the quantity angle
        !
        call angle_t_terms (t, t_terms)



        !
        ! If t is computed using Newton's method, account
        ! for the dependence of t on the control points of u
        !
        if (newton) then

            !
            ! Allocate arrays to store relative positions
            ! of all control points in all B-spline segments
            ! and to store the derivative of t wrt all
            ! control points of u
            !
            if (allocated(cp_pos)) deallocate(cp_pos)
            allocate(cp_pos(ncp))
            if (allocated(dt_dxcp)) deallocate(dt_dxcp)
            allocate(dt_dxcp(ncp))


            ! Compute the derivatives of t_terms wrt t
            call angle_t_terms_ders (t, dt_terms)


            !
            ! Determine the relative positions of all
            ! control points in all B-spline segments
            !
            do i = 2, ncp + 1

                if (j == i) then
                    cp_pos(i - 1)       = 1
                else if (j + 1 == i) then
                    cp_pos(i - 1)       = 2
                else if (j + 2 == i) then
                    cp_pos(i - 1)       = 3
                else if (j + 3 == i) then
                    cp_pos(i - 1)       = 4
                else
                    cp_pos(i - 1)       = 0
                end if

            end do  ! i = 2, ncp + 1


            !
            ! Compute the derivative of t wrt control points of u
            !
            do i = 1, ncp

                ! Sensitivity of t wrt to the ith control point
                if (js == 11 .and. i == 4) then
                    dt_dxcp(i)          = dt_cp (t, cp = xcp(j:j + 3), print_from = 1, k = cp_pos(i))
                else
                    dt_dxcp(i)          = dt_cp (t, cp = xcp(j:j + 3), print_from = 0, k = cp_pos(i))
                end if

                ! Account for ghost control points in the 1st segment
                if (j == 1) then
                    if (cp_pos(i) == 2) &
                         dt_dxcp(i)     = dt_cp01 (t, cp = xcp(j:j + 3))
                    if (cp_pos(i) == 3) &
                         dt_dxcp(i)     = dt_cp11 (t, cp = xcp(j:j + 3))
                end if

                ! Account for ghost control points in the last segment
                if (j == ncp - 1) then
                    if (cp_pos(i) == 2) &
                         dt_dxcp(i)     = dt_cp_ncp_1_last (t, cp = xcp(j:j + 3))
                    if (cp_pos(i) == 3) &
                         dt_dxcp(i)     = dt_cp_ncp_last (t, cp = xcp(j:j + 3))
                end if

            end do  ! i = 1, ncp


            !
            ! Compute derivatives of angle wrt control points of u
            !
            do i = 1, ncp

                sum1                    = 0.0
                do m = 1, 4
                    sum2                = 0.0
                    do l = 1, 4
                        sum2            = sum2 + ((dcpall(i, j + l - 1) * t_terms(m, l)) + &
                                                  (xcp(j + l - 1) * dt_terms(m, l) * dt_dxcp(i)))
                    end do
                    sum1                = sum1 + (ycp(j + m - 1) * sum2)
                end do

                ders (i)                = -sum1

            end do

        else    ! t is not computed using Newton's method

            ! Compute derivatives of angle wrt control points of u
            do i = 1, ncp

                sum1                        = 0.0
                do m = 1, 4
                    sum2                    = 0.0
                    do l = 1, 4
                        sum2                = sum2 + (dcpall(i, j + l - 1) * t_terms(m, l))
                    end do
                    sum1                    = sum1 + (ycp(j + m - 1) * sum2)
                end do

                ders(i)                     = -sum1

            end do

        end if  ! if (newton)


    end subroutine angle_xcp_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of the integral of v''_m(u)
    ! wrt the control points of v''_m(u). This quantity is
    ! computed in the function angle defined in bsplinecam.f90
    !
    ! Input parameters: j       - segment index for the B-spline of
    !                             v''_m(u)
    !                   dcpall  - array containing the derivatives of
    !                             the control points wrt themselves
    !                   xcp     - control points of u
    !                   t       - spline parameter value
    !
    !-----------------------------------------------------------------------------------------------
    subroutine angle_ycp_ders (j, dcpall, xcp, t, ders)

        integer,                intent(in)      :: j
        real,                   intent(in)      :: dcpall(:,:)
        real,                   intent(in)      :: xcp(:)
        real,                   intent(in)      :: t
        real,   allocatable,    intent(inout)   :: ders(:)

        ! Local variables
        integer                                 :: ncp, i, l, m
        real                                    :: sum1, sum2, t_terms(4, 4)


        ! Number of control points
        ncp                             = size(dcpall, 1)

        ! Allocate and initialize result array
        if (allocated(ders)) deallocate(ders)
        allocate(ders(ncp))

        ders = 0.0



        !
        ! Groupings of spline parameter t used
        ! to compute the quantity angle
        !
        call angle_t_terms (t, t_terms)

        ! Compute derivatives
        do i = 1, ncp

            sum1                        = 0.0
            do m = 1, 4
                sum2                    = 0.0
                do l = 1, 4
                    sum2                = sum2 + (xcp(j + l - 1) * t_terms(m, l))
                end do
                sum1                    = sum1 + (dcpall(i, j + m - 1) * sum2)
            end do

            ders(i)                     = -sum1

        end do


    end subroutine angle_ycp_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of integral of
    ! v'_m(u) wrt the control points of u.
    ! This quantity is computed in the function
    ! camber defined in bsplinecam.f90
    !
    ! Input parameters: j           - spline segment index
    !                   dcpall      - array containing derivatives of the spline
    !                                 control points wrt themselves
    !                   xcp         - control points of u
    !                   ycp         - control points of v''_m(u)
    !                   t           - spline parameter value
    !                   angle0      - integral of v''_m(u)
    !                   angle_ders  - derivative of the quantity angle wrt to
    !                                 the control points
    !
    !-----------------------------------------------------------------------------------------------
    subroutine camber_xcp_ders (js, j, dcpall, xcp, ycp, t, angle0, angle_ders, newton, ders)

        integer,                intent(in)      :: js
        integer,                intent(in)      :: j
        real,                   intent(in)      :: dcpall(:,:)
        real,                   intent(in)      :: xcp(:)
        real,                   intent(in)      :: ycp(:)
        real,                   intent(in)      :: t
        real,                   intent(in)      :: angle0
        real,                   intent(in)      :: angle_ders(:)
        logical,    optional,   intent(in)      :: newton
        real,   allocatable,    intent(inout)   :: ders(:)

        ! Local variables
        integer                                 :: ncp, i, l, m, n
        integer,    allocatable                 :: cp_pos(:)
        real                                    :: xterm1, xterm2, xterm3, t_terms(4, 4, 4), &
                                                   dt_terms(4, 4, 4), sum1, sum2, sum3, sum4, sum5
        real,       allocatable                 :: dt_dxcp(:)


        ! Number of control points
        ncp                             = size(dcpall, 1)

        ! Allocate and initialize result array
        if (allocated(ders)) deallocate(ders)
        allocate(ders(ncp))

        ders                            = 0.0



        ! Temporary terms used to compute derivative
        xterm1                          = xcp(j)*(-t**3/6 + t**2/2 - t/2) + xcp(j + 1)*(t**3/2 - t**2) + &
                                          xcp(j + 2)*(-t**3/2 + t**2/2 + t/2) + xcp(j + 3)*(t**3/6)

        ! Groupings of spline parameter t used to
        ! compute the camber
        call camber_t_terms(t, t_terms)



        !
        ! If t is computed using Newton's method, account
        ! for the dependence of t on the control points of u
        !
        if (newton) then

            !
            ! Allocate arrays to store relative positions
            ! of all control points in all B-spline segments
            ! and to store the derivative of t wrt all
            ! control points of u
            !
            if (allocated(cp_pos)) deallocate(cp_pos)
            allocate(cp_pos(ncp))
            if (allocated(dt_dxcp)) deallocate(dt_dxcp)
            allocate(dt_dxcp(ncp))


            ! Compute the derivatives of t_terms wrt t
            call camber_t_terms_ders (t, dt_terms)


            !
            ! Determine the relative positions of all
            ! control points in all B-spline segments
            !
            do i = 2, ncp + 1

                if (j == i) then
                    cp_pos(i - 1)       = 1
                else if (j + 1 == i) then
                    cp_pos(i - 1)       = 2
                else if (j + 2 == i) then
                    cp_pos(i - 1)       = 3
                else if (j + 3 == i) then
                    cp_pos(i - 1)       = 4
                else
                    cp_pos(i - 1)       = 0
                end if

            end do  ! i = 2, ncp + 1


            !
            ! Compute the derivative of t wrt control points of u
            !
            do i = 1, ncp

                ! Sensitivity of t wrt to the ith control point
                dt_dxcp(i)              = dt_cp (t, cp = xcp(j:j + 3), print_from = 0, k = cp_pos(i))

                ! Account for ghost control points in the 1st segment
                if (j == 1) then
                    if (cp_pos(i) == 2) &
                         dt_dxcp(i)     = dt_cp01 (t, cp = xcp(j:j + 3))
                    if (cp_pos(i) == 3) &
                         dt_dxcp(i)     = dt_cp11 (t, cp = xcp(j:j + 3))
                end if

                ! Account for ghost control points in the last segment
                if (j == ncp - 1) then
                    if (cp_pos(i) == 2) &
                         dt_dxcp(i)     = dt_cp_ncp_1_last (t, cp = xcp(j:j + 3))
                    if (cp_pos(i) == 3) &
                         dt_dxcp(i)     = dt_cp_ncp_last (t, cp = xcp(j:j + 3))
                end if

            end do  ! i = 1, ncp


            !
            ! Compute derivatives of camber wrt control points of u
            !
            do i = 1, ncp

                sum1                        = 0.0
                do n = 1, 4
                    sum2                    = 0.0
                    sum3                    = 0.0
                    do m = 1, 4
                        sum4                = 0.0
                        sum5                = 0.0
                        do l = 1, 4
                            sum4            = sum4 + (xcp(j + l - 1) * t_terms(n, m, l))
                            sum5            = sum5 + ((dcpall(i, j + l - 1) * t_terms(n, m, l)) + &
                                                      (xcp(j + l - 1) * dt_terms(n, m, l) * dt_dxcp(i)))
                        end do
                        sum2                = sum2 + (dcpall(i, j + m - 1) * sum4)
                        sum3                = sum3 + (xcp(j + m - 1) * sum5)
                    end do
                    sum1                    = sum1 + (ycp(j + n - 1) * (sum2 + sum3))
                end do

                ! Temporary terms
                xterm2                      = dcpall(i, j)*(-t**3/6 + t**2/2 - t/2) + dcpall(i, j + 1)*(t**3/2 - t**2) + &
                                              dcpall(i, j + 2)*(-t**3/2 + t**2/2 + t/2) + dcpall(i, j + 3)*(t**3/6)
                xterm3                      = (xcp(j) * (((-t**2)/TWO) + t - 0.5)) + (xcp(j + 1) * ((1.5 * (t**2)) - &
                                              (TWO * t))) + (xcp(j + 2) * ((-1.5 * (t**2)) + t + 0.5)) + &
                                              (xcp(j + 3) * (0.5 * (t**2)))

                ders(i)                     = -sum1 + (angle0 * (xterm2 + (xterm3 * dt_dxcp(i)))) + (angle_ders(i) * xterm1)

            end do  ! i = 1, ncp

        else    ! If t is not computed using Newton's method

            !
            ! Compute derivatives of camber wrt control points of u
            !
            do i = 1, ncp

                sum1                        = 0.0
                do n = 1, 4
                    sum2                    = 0.0
                    sum3                    = 0.0
                    do m = 1, 4
                        sum4                = 0.0
                        sum5                = 0.0
                        do l = 1, 4
                            sum4            = sum4 + (xcp(j + l - 1) * t_terms(n, m, l))
                            sum5            = sum5 + (dcpall(i, j + l - 1) * t_terms(n, m, l))
                        end do
                        sum2                = sum2 + (dcpall(i, j + m - 1) * sum4)
                        sum3                = sum3 + (xcp(j + m - 1) * sum5)
                    end do
                    sum1                    = sum1 + (ycp(j + n - 1) * (sum2 + sum3))
                end do

                xterm2                      = dcpall(i, j)*(-t**3/6 + t**2/2 - t/2) + dcpall(i, j + 1)*(t**3/2 - t**2) + &
                                            dcpall(i, j + 2)*(-t**3/2 + t**2/2 + t/2) + dcpall(i, j + 3)*(t**3/6)

                ders(i)                     = -sum1 + (angle0 * xterm2) + (angle_ders(i) * xterm1)

            end do  ! i = 1, ncp

        end if  ! newton


    end subroutine camber_xcp_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of twice integrated
    ! v''_m(u) wrt the control points of v''_m(u).
    ! This quantity is computed in the function
    ! camber defined in bsplinecam.f90
    !
    ! Input parameters: j           - spline segment index
    !                   dcpall      - array containing derivatives of the spline
    !                                 control points wrt themselves
    !                   xcp         - control points of u
    !                   t           - spline parameter value
    !                   angle_ders  - derivative of the quantity angle wrt to
    !                                 the control points
    !
    !-----------------------------------------------------------------------------------------------
    subroutine camber_ycp_ders (j, dcpall, xcp, t, angle_ders, ders)

        integer,                intent(in)      :: j
        real,                   intent(in)      :: dcpall(:,:)
        real,                   intent(in)      :: xcp(:)
        real,                   intent(in)      :: t
        real,                   intent(in)      :: angle_ders(:)
        real,   allocatable,    intent(inout)   :: ders(:)

        ! Local variables
        integer                                 :: ncp, i, l, m, n
        !real                                    :: xterm_1, xterm_2, xterm_3, xterm_4, xterm_5
        real                                    :: xterm, t_terms(4, 4, 4), sum1, sum2, sum3


        ! Number of control points
        ncp                             = size(dcpall, 1)

        ! Allocate and initialize result array
        if (allocated(ders)) deallocate(ders)
        allocate(ders(ncp))

        ders                            = 0.0



        ! Temporary term used to compute derivative
        xterm                           = xcp(j)*(-t**3/6 + t**2/2 - t/2) + xcp(j + 1)*(t**3/2 - t**2) + &
                                          xcp(j + 2)*(-t**3/2 + t**2/2 + t/2) + xcp(j + 3)*(t**3/6)

        ! Groupings of spline parameter t used to
        ! compute the camber
        call camber_t_terms(t, t_terms)



        !
        ! Compute the derivatives
        !
        do i = 1, ncp

            sum1                        = 0.0
            do n = 1, 4
                sum2                    = 0.0
                do m = 1, 4
                    sum3                = 0.0
                    do l = 1, 4
                        sum3            = sum3 + (xcp(j + l - 1) * t_terms(n, m, l))
                    end do
                    sum2                = sum2 + (xcp(j + m - 1) * sum3)
                end do
                sum1                    = sum1 + (dcpall(i, j + n - 1) * sum2)
            end do

            ders(i)                     = -sum1 + (angle_ders(i) * xterm)

        end do  ! i = 1, ncp


    end subroutine camber_ycp_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of P wrt the control
    ! points of u and v''_m(u). P is a grouping of
    ! terms used to compute the scaling factor for
    ! the mean-line second derivative spline
    !
    ! Input parameters: angle           - integral of v''_m(u) from u = 0 to u = 1
    !                   camber          - integral of v'_m(u) from u = 0 to u = 1
    !                   d_angle_xcp     - derivatives of angle wrt control points of u
    !                   d_angle_ycp     - derivatives of angle wrt control points of v''_m(u)
    !                   d_camber_xcp    - derivatives of camber wrt control points of u
    !                   d_camber_ycp    - derivatives of camber wrt control points of v''_m(u)
    !
    !-----------------------------------------------------------------------------------------------
    subroutine compute_P_ders (angle, camber, d_angle_xcp, d_angle_ycp, &
                               d_camber_xcp, d_camber_ycp, dP_xcp, dP_ycp)

        real,                   intent(in)      :: angle
        real,                   intent(in)      :: camber
        real,                   intent(in)      :: d_angle_xcp(:)
        real,                   intent(in)      :: d_angle_ycp(:)
        real,                   intent(in)      :: d_camber_xcp(:)
        real,                   intent(in)      :: d_camber_ycp(:)
        real,   allocatable,    intent(inout)   :: dP_xcp(:)
        real,   allocatable,    intent(inout)   :: dP_ycp(:)

        ! Local variables
        integer                                 :: ncp, i


        ! Number of control points
        ncp                             = size(d_angle_xcp)

        ! Allocate and initialize result arrays
        if (allocated(dP_xcp)) deallocate(dP_xcp)
        allocate(dP_xcp(ncp))
        if (allocated(dP_ycp)) deallocate(dP_ycp)
        allocate(dP_ycp(ncp))

        dP_xcp                          = 0.0
        dP_ycp                          = 0.0



        ! Compute derivatives
        do i = 1, ncp

            ! u control points
            dP_xcp(i)                   = (d_angle_xcp(i) * camber) + (angle * d_camber_xcp(i)) - &
                                          (TWO * camber * d_camber_xcp(i))

            ! v''_m(u) control points
            dP_ycp(i)                   = (d_angle_ycp(i) * camber) + (angle * d_camber_ycp(i)) - &
                                          (TWO * camber * d_camber_ycp(i))

        end do


    end subroutine compute_P_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of det wrt the control
    ! points of u and v''_m(u). det is the determinant
    ! of the quadratic equation used to compute the
    ! scaling factor for the mean-line second derivative
    ! spline
    !
    ! Input parameters: angle       - integral of v''_m(u) from u = 0 to u = 1
    !                   tot_cam     - total camber
    !                   d_angle_xcp - derivatives of angle wrt control points of u
    !                   d_angle_ycp - derivatives of angle wrt control points of v''_m(u)
    !                   dP_xcp      - derivatives of P wrt control points of u
    !                   dP_ycp      - derivatives of P wrt control points of v''_m(u)
    !
    ! dP_xcp and dP_ycp are computed in compute_P_ders
    !
    !-----------------------------------------------------------------------------------------------
    subroutine compute_det_ders (angle, tot_cam, d_angle_xcp, d_angle_ycp, &
                                 dP_xcp, dP_ycp, d_det_xcp, d_det_ycp)

        real,                   intent(in)      :: angle
        real,                   intent(in)      :: tot_cam
        real,                   intent(in)      :: d_angle_xcp(:)
        real,                   intent(in)      :: d_angle_ycp(:)
        real,                   intent(in)      :: dP_xcp(:)
        real,                   intent(in)      :: dP_ycp(:)
        real,   allocatable,    intent(inout)   :: d_det_xcp(:)
        real,   allocatable,    intent(inout)   :: d_det_ycp(:)

        ! Local variables
        integer                                 :: ncp, i


        ! Number of control points
        ncp                             = size(d_angle_xcp)

        ! Allocate and initialize result arrays
        if (allocated(d_det_xcp)) deallocate(d_det_xcp)
        allocate(d_det_xcp(ncp))
        if (allocated(d_det_ycp)) deallocate(d_det_ycp)
        allocate(d_det_ycp(ncp))

        d_det_xcp                       = 0.0
        d_det_ycp                       = 0.0



        ! Compute derivatives
        do i = 1, ncp

            ! u control points
            d_det_xcp(i)                = (TWO * angle * d_angle_xcp(i)) + (FOUR * dP_xcp(i) * (tan(tot_cam)**2))

            ! v''_m(u) control points
            d_det_ycp(i)                = (TWO * angle * d_angle_ycp(i)) + (FOUR * dP_ycp(i) * (tan(tot_cam)**2))

        end do


    end subroutine compute_det_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of k wrt the control points
    ! of u and v''_m(u). k is the scaling factor for the
    ! B-spline representation of the mean-line second
    ! derivative
    !
    ! Input parameters: k1              - 1st root of scaling factor equation
    !                   k2              - 2nd root of scaling factor equation
    !                   knew            - scaling factor
    !                   angle           - integral of v''_m(u) from u = 0 to u = 1
    !                   camber          - integral of v'_m(u) from u = 0 to u = 1
    !                   P               - grouping of terms (= angle*camber - camber**2)
    !                   tot_cam         - total camber
    !                   det             - determinant of the scaling factor quadratic
    !                                     equation
    !                   d_angle_xcp     - derivatives of angle wrt cp of u
    !                   d_angle_ycp     - derivatives of angle wrt cp of v''_m(u)
    !                   d_camber_xcp    - derivatives of camber wrt cp of u
    !                   d_camber_ycp    - derivatives of camber wrt cp of v''_m(u)
    !
    !-----------------------------------------------------------------------------------------------
    subroutine compute_k_ders (k1, k2, knew, angle, camber, P, tot_cam, det, d_angle_xcp, d_angle_ycp, &
                               d_camber_xcp, d_camber_ycp, dk_xcp, dk_ycp)

        real,                   intent(in)      :: k1
        real,                   intent(in)      :: k2
        real,                   intent(in)      :: knew
        real,                   intent(in)      :: angle
        real,                   intent(in)      :: camber
        real,                   intent(in)      :: P
        real,                   intent(in)      :: tot_cam
        real,                   intent(in)      :: det
        real,                   intent(in)      :: d_angle_xcp(:)
        real,                   intent(in)      :: d_angle_ycp(:)
        real,                   intent(in)      :: d_camber_xcp(:)
        real,                   intent(in)      :: d_camber_ycp(:)
        real,   allocatable,    intent(inout)   :: dk_xcp(:)
        real,   allocatable,    intent(inout)   :: dk_ycp(:)

        ! Local variables
        integer                                 :: ncp, i
        real                                    :: tol = 10E-16, M_x, M_y
        real,   allocatable                     :: dP_xcp(:), dP_ycp(:), d_det_xcp(:), d_det_ycp(:)


        ! Number of control points
        ncp                             = size(d_angle_xcp)

        ! Allocate and initialize result arrays
        if (allocated(dk_xcp)) deallocate(dk_xcp)
        allocate(dk_xcp(ncp))
        if (allocated(dk_ycp)) deallocate(dk_ycp)
        allocate(dk_ycp(ncp))

        dk_xcp                          = 0.0
        dk_ycp                          = 0.0



        !
        ! Compute derivatives of P wrt control points
        ! of u and v''_m(u)
        !
        call compute_P_ders (angle, camber, d_angle_xcp, d_angle_ycp, &
                             d_camber_xcp, d_camber_ycp, dP_xcp, dP_ycp)

        ! Compute derivatives of det wrt control points of u and v''_m(u)
        call compute_det_ders (angle, tot_cam, d_angle_xcp, d_angle_ycp, &
                               dP_xcp, dP_ycp, d_det_xcp, d_det_ycp)



        !
        ! Compute derivatives of scaling factor
        ! wrt control points of u and v''_m(u)
        !
        if (abs(knew - k1) < tol) then  ! If k = k1

            do i = 1, ncp

                ! u control points
                M_x                     = -d_angle_xcp(i) + (d_det_xcp(i)/(TWO * sqrt(det)))
                dk_xcp(i)               = knew * ((M_x/(-angle + sqrt(det))) - ((ONE/P) * dP_xcp(i)))

                ! v''_m(u) control points
                M_y                     = -d_angle_ycp(i) + (d_det_ycp(i)/(TWO * sqrt(det)))
                dk_ycp(i)               = knew * ((M_y/(-angle + sqrt(det))) - ((ONE/P) * dP_ycp(i)))
            end do

        else    ! If k = k2

            do i = 1, ncp

                ! u control points
                M_x                     = d_angle_xcp(i) + (d_det_xcp(i)/(TWO * sqrt(det)))
                dk_xcp(i)               = knew * ((M_x/(angle + sqrt(det))) - ((ONE/P) * dP_xcp(i)))

                ! v''_m(u) control points
                M_y                     = d_angle_ycp(i) + (d_det_ycp(i)/(TWO * sqrt(det)))
                dk_ycp(i)               = knew * ((M_y/(angle + sqrt(det))) - ((ONE/P) * dP_ycp(i)))

            end do

        end if


    end subroutine compute_k_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of d1v_end wrt control
    ! points of u. d1v_end stores values of mean-line
    ! first derivative at the end points of the
    ! segments of the associated cubic B-spline
    !
    ! Input parameters: k           - scaling factor
    !                   angle       - values of integral of v''_m(u) at segment
    !                                 endpoints
    !                   camber      - values of integral of v'_m(u) at segment
    !                                 endpoints
    !                   dk_xcp      - derivatives of k wrt u control points
    !                   d_angle_xcp - derivatives of angle wrt control points of
    !                                 u at segment endpoints
    !
    !-----------------------------------------------------------------------------------------------
    subroutine d1v_end_xcp_ders (k, angle, camber, dk_xcp, d_angle_xcp, d_camber_xcp, d1v_end_xcp)

        real,                   intent(in)      :: k
        real,                   intent(in)      :: angle(:)
        real,                   intent(in)      :: camber
        real,                   intent(in)      :: dk_xcp(:)
        real,                   intent(in)      :: d_angle_xcp(:,:)
        real,                   intent(in)      :: d_camber_xcp(:)
        real,   allocatable,    intent(inout)   :: d1v_end_xcp(:,:)

        ! Local variables
        integer                                 :: ncp, i, j


        ! Number of control points
        ncp                             = size(angle)

        !
        ! Allocate and initialize result array
        !
        ! 1st array index tracks B-spline segment index
        ! 2nd array index tracks the control point number
        !
        if (allocated(d1v_end_xcp)) deallocate(d1v_end_xcp)
        allocate(d1v_end_xcp(ncp, ncp))


        ! Compute derivatives
        do i = 1, ncp

            ! d1v_end(i)                = k * (angle(i) - camber)

            do j = 1, ncp
                d1v_end_xcp(i, j)       = (dk_xcp(j) * (angle(i) - camber)) + &
                                          (k * (d_angle_xcp(i, j) - d_camber_xcp(j)))
            end do

        end do


    end subroutine d1v_end_xcp_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of d1v_end wrt control
    ! points of u. d1v_end stores values of mean-line
    ! first derivative at the end points of the
    ! segments of the associated cubic B-spline
    !
    ! Input parameters: k           - scaling factor
    !                   angle       - values of integral of v''_m(u) at segment
    !                                 endpoints
    !                   camber      - values of integral of v'_m(u) at segment
    !                                 endpoints
    !                   dk_ycp      - derivatives of k wrt v''_m(u) control points
    !                   d_angle_ycp - derivatives of angle wrt control points of
    !                                 v''_m(u) at segment endpoints
    !
    !-----------------------------------------------------------------------------------------------
    subroutine d1v_end_ycp_ders (k, angle, camber, dk_ycp, d_angle_ycp, d_camber_ycp, d1v_end_ycp)

        real,                   intent(in)      :: k
        real,                   intent(in)      :: angle(:)
        real,                   intent(in)      :: camber
        real,                   intent(in)      :: dk_ycp(:)
        real,                   intent(in)      :: d_angle_ycp(:,:)
        real,                   intent(in)      :: d_camber_ycp(:)
        real,   allocatable,    intent(inout)   :: d1v_end_ycp(:,:)

        ! Local variables
        integer                                 :: ncp, i, j


        ! Number of control points
        ncp                             = size(angle)

        !
        ! Allocate and initialize result array
        !
        ! 1st array index tracks B-spline segment index
        ! 2nd array index tracks the control point number
        !
        if (allocated(d1v_end_ycp)) deallocate(d1v_end_ycp)
        allocate(d1v_end_ycp(ncp, ncp))


        ! Compute derivatives
        do i = 1, ncp

            ! d1v_end(i)                = k * (angle(i) - camber)

            do j = 1, ncp
                d1v_end_ycp(i, j)       = (dk_ycp(j) * (angle(i) - camber)) + &
                                          (k * (d_angle_ycp(i, j) - d_camber_ycp(j)))
            end do

        end do


    end subroutine d1v_end_ycp_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of v_end wrt control
    ! points of u. v_end stores values of mean-line
    ! second derivative at the end points of the
    ! segments of the associated cubic B-spline
    !
    ! Input parameters: k            - scaling factor
    !                   dk_xcp       - derivatives of k wrt u control points
    !                   camber       - values of integral of v'_m(u) at segment
    !                                  endpoints
    !                   u_end        - values of u at segment endpoints
    !                   d_camber_xcp - derivatives of camber wrt control points of
    !                                  u at segment endpoints
    !                   du_end_xcp   - derivatives of u_end wrt control points of
    !                                  u at segment endpoints
    !
    !-----------------------------------------------------------------------------------------------
    subroutine v_end_xcp_ders (k, camber, u_end, dk_xcp, d_camber_xcp, du_end_xcp, dv_end_xcp)

        real,                   intent(in)      :: k
        real,                   intent(in)      :: camber(:)
        real,                   intent(in)      :: u_end(:)
        real,                   intent(in)      :: dk_xcp(:)
        real,                   intent(in)      :: d_camber_xcp(:,:)
        real,                   intent(in)      :: du_end_xcp(:,:)
        real,   allocatable,    intent(inout)   :: dv_end_xcp(:,:)

        ! Local variables
        integer                                 :: ncp, i, j


        ! Number of control points
        ncp                             = size(dk_xcp)

        !
        ! Allocate and initialize result array
        !
        ! 1st array index tracks B-spline segment index
        ! 2nd array index tracks the control point number
        !
        if (allocated(dv_end_xcp)) deallocate(dv_end_xcp)
        allocate(dv_end_xcp(ncp, ncp))



        ! Compute derivatives
        do i = 1, ncp

            ! v_end(i) = k * (camber(i) - (u_end(i) * camber(ncp)))

            do j = 1, ncp
                dv_end_xcp(i, j)        = (dk_xcp(j) * (camber(i) - (u_end(i) * camber(ncp)))) + &
                                          (k * (d_camber_xcp(i, j) - ((du_end_xcp(i, j) * camber(ncp)) + &
                                          (u_end(i) * d_camber_xcp(ncp, j)))))
            end do

        end do


    end subroutine v_end_xcp_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of v_end wrt control
    ! points of v''_m(u). v_end stores values of mean-line
    ! second derivative at the end points of the
    ! segments of the associated cubic B-spline
    !
    ! Input parameters: k            - scaling factor
    !                   camber       - integral of v'_m(u) at B-spline segment
    !                                  endpoints
    !                   u_end        - values of u at B-spline segment endpoints
    !                   d_camber_ycp - derivatives of camber wrt control points
    !                                  of v''_m(u) at B-spline segment endpoints
    !
    !-----------------------------------------------------------------------------------------------
    subroutine v_end_ycp_ders (js, k, camber, u_end, dk_ycp, d_camber_ycp, dv_end_ycp)

        integer,                intent(in)      :: js
        real,                   intent(in)      :: k
        real,                   intent(in)      :: camber(:)
        real,                   intent(in)      :: u_end(:)
        real,                   intent(in)      :: dk_ycp(:)
        real,                   intent(in)      :: d_camber_ycp(:,:)
        real,   allocatable,    intent(inout)   :: dv_end_ycp(:,:)

        ! Local variables
        integer                                 :: ncp, i, j


        ! Number of control points
        ncp                             = size(d_camber_ycp, 2)

        !
        ! Allocate and initialize result array
        !
        ! 1st array index tracks B-spline segment endpoint index
        ! 2nd array index tracks the control point number
        !
        if (allocated(dv_end_ycp)) deallocate(dv_end_ycp)
        allocate(dv_end_ycp(ncp, ncp))


        ! Compute derivatives
        do i = 1, ncp

            ! v_end(i) = k * (camber(i) - (u_end(i) * camber(ncp)))
            ! du_end/dycp = 0

            do j = 1, ncp
                dv_end_ycp(i, j)        = (dk_ycp(j) * (camber(i) - (u_end(i) * camber(ncp)))) + &
                                          (k * (d_camber_ycp(i, j) - (u_end(i) * d_camber_ycp(ncp, j))))
            end do

        end do


    end subroutine v_end_ycp_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the sensitivity of a (u,v) blade section
    ! with respect to the chordwise control points of
    ! u and v''_m(u). The derivatives are stored in
    ! arrays which combine the u and v''_m(u) derivatives
    ! to mirror t definition of the spanwise control
    ! points
    !
    ! Input parameters: thickness   - thickness value
    !                   slope       - value of v'_m(u)
    !                   dslope_dxcp - derivatives of slope wrt control points
    !                                 of u
    !                   dslope_dycp - derivatives of slope wrt control points
    !                                 of v''_m(u)
    !                   dcam_dxcp   - derivatives of v_m(u) wrt control points
    !                                 of u
    !                   dcam_dycp   - derivatives of v_m(u) wrt control points
    !                                 of v''_m(u)
    !
    !-----------------------------------------------------------------------------------------------
    subroutine uv_chordwise_ders (thickness, slope, dslope_dxcp, dslope_dycp, &
                                  dcam_dxcp, dcam_dycp, dubot_dc, dutop_dc, dvbot_dc, dvtop_dc)

        real,                   intent(in)      :: thickness(:)
        real,                   intent(in)      :: slope(:)
        real,                   intent(in)      :: dslope_dxcp(:,:)
        real,                   intent(in)      :: dslope_dycp(:,:)
        real,                   intent(in)      :: dcam_dxcp(:,:)
        real,                   intent(in)      :: dcam_dycp(:,:)
        real,   allocatable,    intent(inout)   :: dubot_dc(:,:)
        real,   allocatable,    intent(inout)   :: dutop_dc(:,:)
        real,   allocatable,    intent(inout)   :: dvbot_dc(:,:)
        real,   allocatable,    intent(inout)   :: dvtop_dc(:,:)

        ! Local variables
        integer                                 :: np, ncp, i, j, l


        ! Number of points on mean-line
        np                              = size(thickness)

        ! Number of control points
        ncp                             = size(dslope_dxcp, 2)


        !
        ! Allocate and initialize result arrays
        ! The second dimension is reduced from 2ncp
        ! to 2ncp - 2 because u_1 = 0 and u_ncp = 0
        !
        if (allocated(dubot_dc)) deallocate(dubot_dc)
        allocate(dubot_dc(np, (2*ncp) - 2))
        if (allocated(dutop_dc)) deallocate(dutop_dc)
        allocate(dutop_dc(np, (2*ncp) - 2))
        if (allocated(dvbot_dc)) deallocate(dvbot_dc)
        allocate(dvbot_dc(np, (2*ncp) - 2))
        if (allocated(dvtop_dc)) deallocate(dvtop_dc)
        allocate(dvtop_dc(np, (2*ncp) - 2))

        dubot_dc                        = 0.0
        dutop_dc                        = 0.0
        dvbot_dc                        = 0.0
        dvtop_dc                        = 0.0



        ! Compute derivatives
        do i = 1, np

            ! Derivatives wrt control points of u
            do j = 1, ncp - 2
                l                       = j + 1
                dubot_dc(i, j)          = ((thickness(i))/(sqrt(((slope(i))**2 + ONE)**3))) * dslope_dxcp(i, l)
                dutop_dc(i, j)          = -((thickness(i))/(sqrt(((slope(i))**2 + ONE)**3))) * dslope_dxcp(i, l)
                dvbot_dc(i, j)          = dcam_dxcp(i, l) + &
                                          (((thickness(i) * slope(i))/(sqrt((slope(i))**2 + ONE)**3)) * dslope_dxcp(i, l))
                dvtop_dc(i, j)          = dcam_dxcp(i, l) - &
                                          (((thickness(i) * slope(i))/(sqrt((slope(i))**2 + ONE)**3)) * dslope_dxcp(i, l))
            end do

            ! Derivatives wrt control points of v''_m(u)
            do j = ncp - 1, (2*ncp) - 2
                l                       = j - ncp + 2
                dubot_dc(i, j)          = ((thickness(i))/(sqrt(((slope(i))**2 + ONE)**3))) * dslope_dycp(i, l)
                dutop_dc(i, j)          = -((thickness(i))/(sqrt(((slope(i))**2 + ONE)**3))) * dslope_dycp(i, l)
                dvbot_dc(i, j)          = dcam_dycp(i, l) + &
                                          (((thickness(i) * slope(i))/(sqrt((slope(i))**2 + ONE)**3)) * dslope_dycp(i, l))
                dvtop_dc(i, j)          = dcam_dycp(i, l) - &
                                          (((thickness(i) * slope(i))/(sqrt((slope(i))**2 + ONE)**3)) * dslope_dycp(i, l))
            end do

        end do


    end subroutine uv_chordwise_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of a (u, v) section
    ! wrt the spanwise control points of the mean-line
    ! second derivative
    !
    ! Input parameters: thickness   - array containing thickness values
    !                   slope       - array containing values of v'_m(u)
    !                   dslope_dxcp - array containing derivatives of slope
    !                                 wrt chordwise control points of u
    !                   dslope_dycp - array containing derivatives of slope
    !                                 wrt chordwise control points of v''_m(u)
    !                   dcam_dxcp   - array containing derivatives of mean-line
    !                                 wrt chordwise control points of u
    !                   dcam_dycp   - array containing derivatives of mean-line
    !                                 wrt chordwise control points of v''_m(u)
    !
    !-----------------------------------------------------------------------------------------------
    subroutine uv_curv_derivatives (thickness, slope, dslope_dxcp, dslope_dycp, dcam_dxcp, &
                                    dcam_dycp, dub_dcurv, dut_dcurv, dvb_dcurv, dvt_dcurv)
        use globvar,            only: curv_ycp_ders
        use funcNsubs,          only: get_sec_number

        real,                   intent(in)      :: thickness(:)
        real,                   intent(in)      :: slope(:)
        real,                   intent(in)      :: dslope_dxcp(:,:)
        real,                   intent(in)      :: dslope_dycp(:,:)
        real,                   intent(in)      :: dcam_dxcp(:,:)
        real,                   intent(in)      :: dcam_dycp(:,:)
        real,   allocatable,    intent(inout)   :: dub_dcurv(:,:,:)
        real,   allocatable,    intent(inout)   :: dut_dcurv(:,:,:)
        real,   allocatable,    intent(inout)   :: dvb_dcurv(:,:,:)
        real,   allocatable,    intent(inout)   :: dvt_dcurv(:,:,:)

        ! Local variables
        integer                                 :: np, nparams, ncp, js, i, j, k
        real,   allocatable                     :: dub_dc(:,:), dut_dc(:,:), dvb_dc(:,:), dvt_dc(:,:)


        ! Array sizes
        np                              = size(thickness)           ! Number of points along blade surface
        nparams                         = size(curv_ycp_ders, 1)    ! Number of chordwise curvature control points
        ncp                             = size(curv_ycp_ders, 3)    ! Number of spanwise curvature control points

        ! Allocate and initialize output arrays
        if (allocated(dub_dcurv)) deallocate(dub_dcurv)
        allocate(dub_dcurv(np, nparams, ncp))
        if (allocated(dut_dcurv)) deallocate(dut_dcurv)
        allocate(dut_dcurv(np, nparams, ncp))
        if (allocated(dvb_dcurv)) deallocate(dvb_dcurv)
        allocate(dvb_dcurv(np, nparams, ncp))
        if (allocated(dvt_dcurv)) deallocate(dvt_dcurv)
        allocate(dvt_dcurv(np, nparams, ncp))

        dub_dcurv                       = 0.0
        dut_dcurv                       = 0.0
        dvb_dcurv                       = 0.0
        dvt_dcurv                       = 0.0

        ! Get the current spanwise section index
        call get_sec_number (js)


        !
        ! Compute the derivatives of the (u, v) geometry
        ! wrt the chordwise control points of u and v''_m(u)
        !
        call uv_chordwise_ders (thickness, slope, dslope_dxcp, dslope_dycp, dcam_dxcp, dcam_dycp, &
                                dub_dc, dut_dc, dvb_dc, dvt_dc)



        !
        ! Compute the derivatives of the (u, v) geometry
        ! wrt the spanwise control points of u and v''_m(u)
        ! using a chain rule. The js loop (through the spanwise
        ! sections) is running in bladegen.f90 where this
        ! subroutine is called
        !
        do i = 1, np
            do j = 1, nparams
                do k = 1, ncp
                    dub_dcurv(i, j, k)  = dub_dc(i, j) * curv_ycp_ders(j + 1, js, k)
                    dut_dcurv(i, j, k)  = dut_dc(i, j) * curv_ycp_ders(j + 1, js, k)
                    dvb_dcurv(i, j, k)  = dvb_dc(i, j) * curv_ycp_ders(j + 1, js, k)
                    dvt_dcurv(i, j, k)  = dvt_dc(i, j) * curv_ycp_ders(j + 1, js, k)
                end do
            end do
        end do


    end subroutine uv_curv_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of the (u, v) blade
    ! sections wrt the thickness distribution
    ! parameter control points
    !
    ! Input parameters: np          - number of points along top and bottom
    !                                 blade surfaces
    !                   NACA_ders   - derivatives of NACA thickness wrt
    !                                 thickness parameters for a spanwise section
    !                   angle       - sin(arctan(v'_m(u)))
    !
    !-----------------------------------------------------------------------------------------------
    subroutine uv_thk_derivatives (np, u_ders, NACA_ders, slope_ders, cam_ders, thickness, &
                                   angle, slope, dubot_dt, dvbot_dt, dutop_dt, dvtop_dt)
        use globvar,            only: thk_ycp_ders, clustering_switch
        use funcNsubs,          only: get_sec_number

        integer,                intent(in)      :: np
        real,                   intent(in)      :: u_ders(np, 5)
        real,                   intent(in)      :: NACA_ders(np, 5)
        real,                   intent(in)      :: slope_ders(np, 5)
        real,                   intent(in)      :: cam_ders(np, 5)
        real,                   intent(in)      :: thickness(np)
        real,                   intent(in)      :: angle(np)
        real,                   intent(in)      :: slope(np)
        real,   allocatable,    intent(inout)   :: dubot_dt(:,:,:)
        real,   allocatable,    intent(inout)   :: dvbot_dt(:,:,:)
        real,   allocatable,    intent(inout)   :: dutop_dt(:,:,:)
        real,   allocatable,    intent(inout)   :: dvtop_dt(:,:,:)

        ! Local variables
        integer                                 :: nparams, ncp, i, j, k, js
        real                                    :: temp, dubot(np, 5), dvbot(np, 5), dutop(np, 5), dvtop(np, 5)


        ! Get the current spanwise section index
        call get_sec_number (js)


        !
        ! Compute the derivatives of the (u, v) blade
        ! sections wrt the thickness distribution
        ! parameters
        !
        if (clustering_switch == 4) then    ! Ellipse-based clustering

            do i = 1, np

                ! Temporary term
                temp                        = sqrt((ONE + (slope(i))**2)**3)

                do j = 1, 5
                    dubot(i, j)             = u_ders(i, j) + (0.5 * NACA_ders(i, j) * sin(angle(i))) + &
                                              ((thickness(i)/temp) * slope_ders(i, j))
                    dvbot(i, j)             = cam_ders(i, j) - (0.5 * NACA_ders(i, j) * cos(angle(i))) + &
                                              (((thickness(i) * slope(i))/temp) * slope_ders(i, j))
                    dutop(i, j)             = u_ders(i, j) - (0.5 * NACA_ders(i, j) * sin(angle(i))) - &
                                              ((thickness(i)/temp) * slope_ders(i, j))
                    dvtop(i, j)             = cam_ders(i, j) + (0.5 * NACA_ders(i, j) * cos(angle(i))) - &
                                              (((thickness(i) * slope(i))/temp) * slope_ders(i, j))
                end do

            end do

        else    ! Without ellipse-based clustering

            do i = 1, np

                do j = 1, 5

                    if (j == 3 .or. j == 4) then
                        dubot(i, j)         =  0.5 * sin(angle(i)) * NACA_ders(i, j)
                        dvbot(i, j)         = -0.5 * cos(angle(i)) * NACA_ders(i, j)
                        dutop(i, j)         = -0.5 * sin(angle(i)) * NACA_ders(i, j)
                        dvtop(i, j)         =  0.5 * cos(angle(i)) * NACA_ders(i, j)
                    else
                        dubot(i, j)         =  sin(angle(i)) * NACA_ders(i, j)
                        dvbot(i, j)         = -cos(angle(i)) * NACA_ders(i, j)
                        dutop(i, j)         = -sin(angle(i)) * NACA_ders(i, j)
                        dvtop(i, j)         =  cos(angle(i)) * NACA_ders(i, j)
                    end if

                end do

            end do

        end if


        ! Number of thickness distribution parameters and
        ! number of spanwise control points
        nparams                         = size(thk_ycp_ders, 1)
        ncp                             = size(thk_ycp_ders, 3)


        !
        ! Allocate output arrays
        !
        if (allocated(dubot_dt)) deallocate(dubot_dt)
        allocate(dubot_dt(np, nparams, ncp))
        if (allocated(dvbot_dt)) deallocate(dvbot_dt)
        allocate(dvbot_dt(np, nparams, ncp))
        if (allocated(dutop_dt)) deallocate(dutop_dt)
        allocate(dutop_dt(np, nparams, ncp))
        if (allocated(dvtop_dt)) deallocate(dvtop_dt)
        allocate(dvtop_dt(np, nparams, ncp))


        !
        ! Compute the derivatives of the (u, v) blade sections
        ! wrt the thickness distribution parameter control
        ! points
        !
        do i = 1, np
            do j = 1, nparams
                do k = 1, ncp
                    dubot_dt(i, j, k)   = dubot(i, j) * thk_ycp_ders(j + 1, js, k)
                    dvbot_dt(i, j, k)   = dvbot(i, j) * thk_ycp_ders(j + 1, js, k)
                    dutop_dt(i, j, k)   = dutop(i, j) * thk_ycp_ders(j + 1, js, k)
                    dvtop_dt(i, j, k)   = dvtop(i, j) * thk_ycp_ders(j + 1, js, k)
                end do
            end do
        end do


    end subroutine uv_thk_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Combine the derivatives of the top and bottom
    ! surfaces of a (u,v) blade section into a single
    ! array
    !
    ! Input parameters: dubot - array containing derivatives of u for the
    !                           bottom surface
    !                   dvbot - array containing derivatives of v for the
    !                           bottom surface
    !                   dutop - array containing derivatives of u for the
    !                           top surface
    !                   dvtop - array containing derivatives of v for the
    !                           top surface
    !
    !-----------------------------------------------------------------------------------------------
    subroutine combine_uv_derivatives (dubot, dvbot, dutop, dvtop, du, dv)

        real,                   intent(in)      :: dubot(:,:,:)
        real,                   intent(in)      :: dvbot(:,:,:)
        real,                   intent(in)      :: dutop(:,:,:)
        real,                   intent(in)      :: dvtop(:,:,:)
        real,   allocatable,    intent(inout)   :: du(:,:,:)
        real,   allocatable,    intent(inout)   :: dv(:,:,:)

        ! Local variables
        integer                                 :: np, nparams, ncp, i, j, k


        ! Dimensions of bottom and top derivative arrays
        np                              = size(dubot, 1)
        nparams                         = size(dubot, 2)
        ncp                             = size(dubot, 3)

        ! Allocate output arrays
        if (allocated(du)) deallocate(du)
        allocate(du((2*np) - 1, nparams, ncp))
        if (allocated(dv)) deallocate(dv)
        allocate(dv((2*np) - 1, nparams, ncp))



        !
        ! Combine top and bottom surface derivative arrays
        !
        do i = 1, np
            do j = 1, nparams
                do k = 1, ncp
                    du(i, j, k)         = dutop(np - i + 1, j, k)
                    dv(i, j, k)         = dvtop(np - i + 1, j, k)
                end do
            end do
        end do

        do i = 2, np
            do j = 1, nparams
                do k = 1, ncp
                    du(i + np - 1, j, k)= dubot(i, j, k)
                    dv(i + np - 1, j, k)= dvbot(i, j, k)
                end do
            end do
        end do


    end subroutine combine_uv_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute derivatives of (m', theta) blade sections
    ! wrt the control points of the thickness distribution
    ! parameters
    !
    ! Input parameters: du_dt   - derivatives of u coordinates of blade section
    !                   dv_dt   - derivatives of v coordinates of blade section
    !                   chrdx   - non-dimensional actual chord
    !                   chrd    - non-dimensional chord
    !                   sang    - stagger
    !
    !-----------------------------------------------------------------------------------------------
    subroutine mprime_theta_thk_derivatives (du_dt, dv_dt, chrdx, chrd, sang, dm_dt, dth_dt)
        use globvar,            only: chord_switch

        real,                   intent(in)      :: du_dt(:,:,:)
        real,                   intent(in)      :: dv_dt(:,:,:)
        real,                   intent(in)      :: chrdx
        real,                   intent(in)      :: chrd
        real,                   intent(in)      :: sang
        real,                   intent(inout)   :: dm_dt(:,:,:)
        real,                   intent(inout)   :: dth_dt(:,:,:)

        ! Local variables
        integer                                 :: np, nparams, ncp, i, j, k
        real                                    :: chord


        ! Input array dimensions
        np                              = size(du_dt, 1)
        nparams                         = size(du_dt, 2)
        ncp                             = size(du_dt, 3)


        ! Set chord
        if (chord_switch == 1) then
            chord                       = chrdx
        else
            chord                       = chrd
        end if


        ! Compute derivatives
        do i = 1, np
            do j = 1, nparams
                do k = 1, ncp
                    dm_dt(i, j, k)      = chord * ((du_dt(i, j, k) * cos(sang)) - (dv_dt(i, j, k) * sin(sang)))
                    dth_dt(i, j, k)     = chord * ((du_dt(i, j, k) * sin(sang)) + (dv_dt(i, j, k) * cos(sang)))
                end do
            end do
        end do


    end subroutine mprime_theta_thk_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute derivatives of (m', theta) blade sections
    ! wrt the control points of the mean-line second
    ! derivative control points
    !
    ! Input parameters: du_dcurv    - derivatives of u coordinate of blade section
    !                   dv_dcurv    - derivatives of v coordinate of blade section
    !                   mprime      - m' coordinates for the current blade section
    !                   theta       - theta coordinates for the current blade section
    !                   chrdx       - non-dimensional actual chord
    !                   chrd        - non-dimensional chord
    !                   sang        - stagger
    !                   dchrd_dcurv - derivatives of chrd wrt control points of u and v''_m(u)
    !                   dsang_dcurv - derivatives of sang wrt control points of u and v''_m(u)
    !
    !-----------------------------------------------------------------------------------------------
    subroutine mprime_theta_curv_derivatives (du_dcurv, dv_dcurv, mprime, theta, chrdx, chrd, sang, &
                                              dchrd_dcurv, dsang_dcurv, dm_dcurv, dth_dcurv)
        use globvar,            only: chord_switch, curv_ycp_ders
        use funcNsubs,          only: get_sec_number

        real,                   intent(in)      :: du_dcurv(:,:,:)
        real,                   intent(in)      :: dv_dcurv(:,:,:)
        real,                   intent(in)      :: mprime(:)
        real,                   intent(in)      :: theta(:)
        real,                   intent(in)      :: chrdx
        real,                   intent(in)      :: chrd
        real,                   intent(in)      :: sang
        real,                   intent(in)      :: dchrd_dcurv(:)
        real,                   intent(in)      :: dsang_dcurv(:)
        real,                   intent(inout)   :: dm_dcurv(:,:,:)
        real,                   intent(inout)   :: dth_dcurv(:,:,:)

        ! Local variables
        integer                                 :: js, np, nparams, ncp, i, j, k
        real,   allocatable                     :: dchrd_span(:,:), dsang_span(:,:)


        ! Get spanwise section index
        call get_sec_number (js)


        ! Input array dimensions
        np                              = size(du_dcurv, 1)
        nparams                         = size(du_dcurv, 2)
        ncp                             = size(du_dcurv, 3)


        !
        ! Compute derivatives of non-dimensional chord
        ! and stagger wrt spanwise control points of u
        ! and v''_m(u)
        !
        ! Allocate arrays
        if (allocated(dchrd_span)) deallocate(dchrd_span)
        allocate(dchrd_span(nparams, ncp))
        if (allocated(dsang_span)) deallocate(dsang_span)
        allocate(dsang_span(nparams, ncp))

        do j = 1, nparams
            do k = 1, ncp
                dchrd_span(j, k)        = dchrd_dcurv(j) * curv_ycp_ders(j + 1, js, k)
                dsang_span(j, k)        = dsang_dcurv(j) * curv_ycp_ders(j + 1, js, k)
            end do
        end do


        ! Compute derivatives
        if (chord_switch == 1) then ! using non-dimensional actual chord

            do i = 1, np
                do j = 1, nparams
                    do k = 1, ncp
                        dm_dcurv(i, j, k) &
                                        = chrdx * ((du_dcurv(i, j, k) * cos(sang)) - (dv_dcurv(i, j, k) * sin(sang)) - &
                                                   ((theta(i)/chrdx) * dsang_span(j, k)))
                        dth_dcurv(i, j, k) &
                                        = chrdx * ((du_dcurv(i, j, k) * sin(sang)) + (dv_dcurv(i, j, k) * cos(sang)) + &
                                                   ((mprime(i)/chrdx) * dsang_span(j, k)))
                    end do
                end do
            end do

        else    ! using either internal chord definition or spanwise chord multiplier

            do i = 1, np
                do j = 1, nparams
                    do k = 1, ncp
                        dm_dcurv(i, j, k) &
                                        = ((mprime(i)/chrd) * dchrd_span(j, k)) + (chrd * ((du_dcurv(i, j, k) * cos(sang)) - &
                                          (dv_dcurv(i, j, k) * sin(sang)) - ((theta(i)/chrd) * dsang_span(j, k))))
                        dth_dcurv(i, j, k) &
                                        = ((theta(i)/chrd) * dchrd_span(j, k)) + (chrd * ((du_dcurv(i, j, k) * sin(sang)) + &
                                          (dv_dcurv(i, j, k) * cos(sang)) + ((mprime(i)/chrd) * dsang_span(j, k))))
                    end do
                end do
            end do

        end if


    end subroutine mprime_theta_curv_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the sensitivity of the inlet angle wrt
    ! the control points of span and in_beta* specified
    ! in 3dbgbinput when using incidence spline option
    !
    ! Input parameters: temp_in         - inlet angle values specified in 3dbgbinput file
    !                   inci_xcp_ders   - spanwise derivatives of incidence wrt control points
    !                                     of non-dimensional span
    !                   inci_ycp_ders   - spanwise derivatives of incidence wrt control points
    !                                     of incidence (in_beta*)
    !
    !-----------------------------------------------------------------------------------------------
    subroutine in_beta_ders (temp_in, inci_xcp_ders, inci_ycp_ders, in_beta_xcp_ders, in_beta_ycp_ders)

        real,                   intent(in)      :: temp_in(:)
        real,                   intent(in)      :: inci_xcp_ders(:,:)
        real,                   intent(in)      :: inci_ycp_ders(:,:)
        real,                   intent(inout)   :: in_beta_xcp_ders(:,:)
        real,                   intent(inout)   :: in_beta_ycp_ders(:,:)

        ! Local variables
        integer                                 :: nspan, i


        ! Number of spanwise sections
        nspan                           = size(temp_in)


        ! Compute derivatives
        do i = 1, nspan

            ! Positive inlet angle
            if (temp_in(i) >=  ZERO) then

                in_beta_xcp_ders(i, :)  = -inci_xcp_ders(i, :)
                in_beta_ycp_ders(i, :)  = -inci_ycp_ders(i, :)

            ! Negative inlet angle
            else

                in_beta_xcp_ders(i, :)  = inci_xcp_ders(i, :)
                in_beta_ycp_ders(i, :)  = inci_ycp_ders(i, :)

            end if

        end do


    end subroutine in_beta_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of the inlet angle slope
    ! wrt the control points of Span and in_beta*
    !
    ! Input parameters: dtor            - pi/180.0
    !                   in_beta         - inlet angle
    !                   phi_s_in        - dr/dx = (dr/dm')/(dx/dm')
    !                   dinbeta_xcp     - derivatives of in_beta wrt Span control points
    !                   dinbeta_ycp     - derivatives of in_beta wrt in_beta* control points
    !
    !-----------------------------------------------------------------------------------------------
    subroutine sinl_ders (dtor, in_beta, phi_s_in, dinbeta_dxcp, dinbeta_dycp, &
                          dsinl_dxcp, dsinl_dycp)
        use globvar,            only: beta_switch, cpinbeta

        real,                   intent(in)      :: dtor ! pi/180.0
        real,                   intent(in)      :: in_beta
        real,                   intent(in)      :: phi_s_in
        real,                   intent(in)      :: dinbeta_dxcp(:)
        real,                   intent(in)      :: dinbeta_dycp(:)
        real,                   intent(inout)   :: dsinl_dxcp(:)
        real,                   intent(inout)   :: dsinl_dycp(:)

        ! Local variables
        integer                                 :: i


        ! Compute derivatives
        do i = 1, cpinbeta

            ! All axial
            if (beta_switch == 0) then

                dsinl_dxcp(i)           = (dtor/(cos(in_beta * dtor))**2) * cos(phi_s_in) * dinbeta_dxcp(i)
                dsinl_dycp(i)           = (dtor/(cos(in_beta * dtor))**2) * cos(phi_s_in) * dinbeta_dycp(i)

            ! All radial
            else if (beta_switch == 1) then

                dsinl_dxcp(i)           = (dtor/(cos(in_beta * dtor))**2) * sin(phi_s_in) * dinbeta_dxcp(i)
                dsinl_dycp(i)           = (dtor/(cos(in_beta * dtor))**2) * sin(phi_s_in) * dinbeta_dycp(i)

            ! Axial IN - radial OUT
            else if (beta_switch == 2) then

                dsinl_dxcp(i)           = (dtor/(cos(in_beta * dtor))**2) * cos(phi_s_in) * dinbeta_dxcp(i)
                dsinl_dycp(i)           = (dtor/(cos(in_beta * dtor))**2) * cos(phi_s_in) * dinbeta_dycp(i)

            ! Radial IN - axial OUT
            else if (beta_switch == 3) then
                dsinl_dxcp(i)           = (dtor/(cos(in_beta * dtor))**2) * sin(phi_s_in) * dinbeta_dxcp(i)
                dsinl_dycp(i)           = (dtor/(cos(in_beta * dtor))**2) * sin(phi_s_in) * dinbeta_dycp(i)

            end if  ! beta_switch

        end do


    end subroutine sinl_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of the scaling factor
    ! for mean-line second derivative wrt the control
    ! points of Span (inlet flow angle) and in_beta*
    ! specified in 3dbgbinput file
    !
    ! Input parameters: k1          - possible value of scaling factor
    !                   k2          - possible value of scaling factor
    !                   k           - scaling factor
    !                   ainl        - blade inlet angle
    !                   dsinl_dxcp  - derivatives of tan(ainl) wrt the control
    !                                 points of Span
    !                   dsinl_dycp  - derivatives of tan(ainl) wrt the control
    !                                 points of in_beta*
    !                   tot_cam     - total camber
    !                   P           - grouping of terms used in k quadratic equation
    !                   det         - determinant of k quadratic equation
    !
    !-----------------------------------------------------------------------------------------------
    subroutine compute_k_inbeta_ders (k1, k2, k, ainl, dsinl_dxcp, dsinl_dycp, tot_cam, P, det, &
                                      dk_dxcp, dk_dycp)

        real,                   intent(in)      :: k1
        real,                   intent(in)      :: k2
        real,                   intent(in)      :: k
        real,                   intent(in)      :: ainl
        real,                   intent(in)      :: dsinl_dxcp(:)
        real,                   intent(in)      :: dsinl_dycp(:)
        real,                   intent(in)      :: tot_cam
        real,                   intent(in)      :: P
        real,                   intent(in)      :: det
        real,   allocatable,    intent(inout)   :: dk_dxcp(:)
        real,   allocatable,    intent(inout)   :: dk_dycp(:)

        ! Local variables
        real,   parameter                       :: tol = 10E-16
        integer                                 :: cpinbeta, i
        real,   allocatable                     :: dC_dxcp(:), dC_dycp(:), ddet_dxcp(:), ddet_dycp(:)


        ! Number of control points of Span and in_beta*
        cpinbeta                        = size(dsinl_dxcp)


        ! Allocate and initialize output arrays
        if (allocated(dk_dxcp)) deallocate(dk_dxcp)
        allocate(dk_dxcp(cpinbeta))
        if (allocated(dk_dycp)) deallocate(dk_dycp)
        allocate(dk_dycp(cpinbeta))

        dk_dxcp                         = 0.0
        dk_dycp                         = 0.0


        !
        ! Compute derivatives of total camber wrt control points
        ! of Span and in_beta*
        !
        if (allocated(dC_dxcp)) deallocate(dC_dxcp)
        allocate(dC_dxcp(cpinbeta))
        if (allocated(dC_dycp)) deallocate(dC_dycp)
        allocate(dC_dycp(cpinbeta))

        do i = 1, cpinbeta
            dC_dxcp(i)                  = -(ONE/(ONE + ((tan(ainl))**2))) * dsinl_dxcp(i)
            dC_dycp(i)                  = -(ONE/(ONE + ((tan(ainl))**2))) * dsinl_dycp(i)
        end do


        !
        ! Compute derivatives of determinant wrt control points
        ! of Span and in_beta*
        !
        if (allocated(ddet_dxcp)) deallocate(ddet_dxcp)
        allocate(ddet_dxcp(cpinbeta))
        if (allocated(ddet_dycp)) deallocate(ddet_dycp)
        allocate(ddet_dycp(cpinbeta))

        do i = 1, cpinbeta
            ddet_dxcp(i)                = ((EIGHT * P)/((cos(tot_cam))**2)) * tan(tot_cam) * dC_dxcp(i)
            ddet_dycp(i)                = ((EIGHT * P)/((cos(tot_cam))**2)) * tan(tot_cam) * dC_dycp(i)
        end do


        ! Compute derivatives
        if (abs(k - k1) < tol) then ! k = k1

            do i = 1, cpinbeta
                dk_dxcp(i)              = ((ONE/(FOUR * P * tan(tot_cam) * sqrt(det))) * ddet_dxcp(i)) - &
                                          ((k/(tan(tot_cam) * ((cos(tot_cam))**2))) * dC_dxcp(i))
                dk_dycp(i)              = ((ONE/(FOUR * P * tan(tot_cam) * sqrt(det))) * ddet_dycp(i)) - &
                                          ((k/(tan(tot_cam) * ((cos(tot_cam))**2))) * dC_dycp(i))
            end do

        else    ! k = k2

            do i = 1, cpinbeta
                dk_dxcp(i)              = -((ONE/(FOUR * P * tan(tot_cam) * sqrt(det))) * ddet_dxcp(i)) - &
                                           ((k/(tan(tot_cam) * ((cos(tot_cam))**2))) * dC_dxcp(i))
                dk_dycp(i)              = -((ONE/(FOUR * P * tan(tot_cam) * sqrt(det))) * ddet_dycp(i)) - &
                                           ((k/(tan(tot_cam) * ((cos(tot_cam))**2))) * dC_dycp(i))
            end do

        end if  ! k


    end subroutine compute_k_inbeta_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute derivatives of d1v_end computed in bsplinecam.f90
    ! wrt the control points of Span and in_beta* specified in
    ! 3dbgbinput file
    !
    ! Input parameters: k            - scaling factor
    !                   d1v_end      - array with d1v_end values
    !                   dk_dx_inbeta - derivatives of k wrt control points of
    !                                  Span
    !                   dk_dy_inbeta - derivatives of k wrt control points of
    !                                  in_beta*
    !
    !-----------------------------------------------------------------------------------------------
    subroutine d1v_end_inbeta_ders (k, d1v_end, dk_dx_inbeta, dk_dy_inbeta, &
                                    d1v_end_dx_inbeta, d1v_end_dy_inbeta)

        real,                   intent(in)      :: k
        real,                   intent(in)      :: d1v_end(:)
        real,                   intent(in)      :: dk_dx_inbeta(:)
        real,                   intent(in)      :: dk_dy_inbeta(:)
        real,   allocatable,    intent(inout)   :: d1v_end_dx_inbeta(:,:)
        real,   allocatable,    intent(inout)   :: d1v_end_dy_inbeta(:,:)

        ! Local variables
        integer                                 :: nseg, cpinbeta, i, j


        ! Number of segments in mean-line second
        ! derivative B-spline
        nseg                            = size(d1v_end)

        ! Number of control points of in_beta*
        cpinbeta                        = size(dk_dx_inbeta)


        ! Allocate and initialize output arrays
        if (allocated(d1v_end_dx_inbeta)) deallocate(d1v_end_dx_inbeta)
        allocate(d1v_end_dx_inbeta(nseg, cpinbeta))
        if (allocated(d1v_end_dy_inbeta)) deallocate(d1v_end_dy_inbeta)
        allocate(d1v_end_dy_inbeta(nseg, cpinbeta))

        d1v_end_dx_inbeta               = 0.0
        d1v_end_dy_inbeta               = 0.0


        ! Compute derivatives
        do i = 1, nseg
            do j = 1, cpinbeta
                d1v_end_dx_inbeta(i, j) = dk_dx_inbeta(j) * (d1v_end(i)/k)
                d1v_end_dy_inbeta(i, j) = dk_dy_inbeta(j) * (d1v_end(i)/k)
            end do
        end do


    end subroutine d1v_end_inbeta_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute derivatives of v_end computed in bsplinecam.f90
    ! wrt the control points of Span and in_beta* specified in
    ! 3dbgbinput file
    !
    ! Input parameters: k            - scaling factor
    !                   v_end        - array with v_end values
    !                   dk_dx_inbeta - derivatives of k wrt control points of
    !                                  Span
    !                   dk_dy_inbeta - derivatives of k wrt control points of
    !                                  in_beta*
    !
    !-----------------------------------------------------------------------------------------------
    subroutine v_end_inbeta_ders (k, v_end, dk_dx_inbeta, dk_dy_inbeta, &
                                  dv_end_dx_inbeta, dv_end_dy_inbeta)

        real,                   intent(in)      :: k
        real,                   intent(in)      :: v_end(:)
        real,                   intent(in)      :: dk_dx_inbeta(:)
        real,                   intent(in)      :: dk_dy_inbeta(:)
        real,   allocatable,    intent(inout)   :: dv_end_dx_inbeta(:,:)
        real,   allocatable,    intent(inout)   :: dv_end_dy_inbeta(:,:)

        ! Local variables
        integer                                 :: nseg, cpinbeta, i, j


        ! Number of segments in mean-line second
        ! derivative B-spline
        nseg                            = size(v_end)

        ! Number of control points of in_beta*
        cpinbeta                        = size(dk_dx_inbeta)


        ! Allocate and initialize output arrays
        if (allocated(dv_end_dx_inbeta)) deallocate(dv_end_dx_inbeta)
        allocate(dv_end_dx_inbeta(nseg, cpinbeta))
        if (allocated(dv_end_dy_inbeta)) deallocate(dv_end_dy_inbeta)
        allocate(dv_end_dy_inbeta(nseg, cpinbeta))

        dv_end_dx_inbeta                = 0.0
        dv_end_dy_inbeta                = 0.0


        ! Compute derivatives
        do i = 1, nseg
            do j = 1, cpinbeta
                dv_end_dx_inbeta(i, j)  = dk_dx_inbeta(j) * (v_end(i)/k)
                dv_end_dy_inbeta(i, j)  = dk_dy_inbeta(j) * (v_end(i)/k)
            end do
        end do


    end subroutine v_end_inbeta_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of a (u, v) section
    ! wrt the control points of Span and in_beta*
    !
    ! Input parameters: thickness        - thickness distribution values
    !                   slope            - mean-line first derivative values
    !                   dslope_dx_inbeta - derivatives of v'_m(u) wrt control points
    !                                      of Span
    !                   dslope_dy_inbeta - derivatives of v'_m(u) wrt control points
    !                                      of in_beta*
    !                   dcam_dx_inbeta   - derivatives of v_m(u) wrt control points
    !                                      of Span
    !                   dcam_dy_inbeta   - derivatives of v_m(u) wrt control points
    !                                      of in_beta*
    !
    !-----------------------------------------------------------------------------------------------
    subroutine uv_inbeta_derivatives (thickness, slope, dslope_dx_inbeta, dslope_dy_inbeta, dcam_dx_inbeta, &
                                      dcam_dy_inbeta, dxbot_dinbeta, dybot_dinbeta, dxtop_dinbeta,          &
                                      dytop_dinbeta)
        use funcNsubs,          only: get_sec_number

        real,                   intent(in)      :: thickness(:)
        real,                   intent(in)      :: slope(:)
        real,                   intent(in)      :: dslope_dx_inbeta(:,:)
        real,                   intent(in)      :: dslope_dy_inbeta(:,:)
        real,                   intent(in)      :: dcam_dx_inbeta(:,:)
        real,                   intent(in)      :: dcam_dy_inbeta(:,:)
        real,   allocatable,    intent(inout)   :: dxbot_dinbeta(:,:,:)
        real,   allocatable,    intent(inout)   :: dybot_dinbeta(:,:,:)
        real,   allocatable,    intent(inout)   :: dxtop_dinbeta(:,:,:)
        real,   allocatable,    intent(inout)   :: dytop_dinbeta(:,:,:)

        ! Local variables
        integer                                 :: js, np, cpinbeta, i, j


        ! Spanwise section index
        call get_sec_number (js)

        ! Number of points
        np                              = size(dslope_dx_inbeta, 1)

        ! Number of control points
        cpinbeta                        = size(dslope_dx_inbeta, 2)

        ! Allocate and initialize output arrays
        if (allocated(dxbot_dinbeta)) deallocate(dxbot_dinbeta)
        allocate(dxbot_dinbeta(np, 2, cpinbeta))
        if (allocated(dybot_dinbeta)) deallocate(dybot_dinbeta)
        allocate(dybot_dinbeta(np, 2, cpinbeta))
        if (allocated(dxtop_dinbeta)) deallocate(dxtop_dinbeta)
        allocate(dxtop_dinbeta(np, 2, cpinbeta))
        if (allocated(dytop_dinbeta)) deallocate(dytop_dinbeta)
        allocate(dytop_dinbeta(np, 2, cpinbeta))

        dxbot_dinbeta                   = 0.0
        dybot_dinbeta                   = 0.0
        dxtop_dinbeta                   = 0.0
        dytop_dinbeta                   = 0.0


        ! Compute derivatives
        do i = 1, np
            do j = 1, cpinbeta

                ! Span control points
                dxbot_dinbeta(i, 1, j)  = ((thickness(i)/(ONE + (slope(i))**2))) * dslope_dx_inbeta(i, j)
                dybot_dinbeta(i, 1, j)  = dcam_dx_inbeta(i, j) + &
                                          (((thickness(i) * slope(i))/(ONE + (slope(i))**2)) * dslope_dx_inbeta(i, j))
                dxtop_dinbeta(i, 1, j)  = -((thickness(i)/(ONE + (slope(i))**2))) * dslope_dx_inbeta(i, j)
                dytop_dinbeta(i, 1, j)  = dcam_dx_inbeta(i, j) - &
                                          (((thickness(i) * slope(i))/(ONE + (slope(i))**2)) * dslope_dx_inbeta(i, j))

                ! in_beta* control points
                dxbot_dinbeta(i, 2, j)  = ((thickness(i)/(ONE + (slope(i))**2))) * dslope_dy_inbeta(i, j)
                dybot_dinbeta(i, 2, j)  = dcam_dy_inbeta(i, j) + &
                                          (((thickness(i) * slope(i))/(ONE + (slope(i))**2)) * dslope_dy_inbeta(i, j))
                dxtop_dinbeta(i, 2, j)  = -((thickness(i)/(ONE + (slope(i))**2))) * dslope_dy_inbeta(i, j)
                dytop_dinbeta(i, 2, j)  = dcam_dy_inbeta(i, j) - &
                                          (((thickness(i) * slope(i))/(ONE + (slope(i))**2)) * dslope_dy_inbeta(i, j))

            end do
        end do

    end subroutine uv_inbeta_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of a (m',theta) section
    ! wrt the control points of Span and in_beta*
    !
    ! Input parameters: mprime          - m' coordinate of blade section
    !                   theta           - theta coordinate of blade section
    !                   chrdx           - non-dimensional actual chord
    !                   chrd            - non-dimensional chord
    !                   sang            - stagger
    !                   dchrd_dx_inbeta - derivatives of chrd wrt control points
    !                                     of Span
    !                   dchrd_dy_inbeta - derivatives of chrd wrt control points
    !                                     of in_beta*
    !                   dsang_dx_inbeta - derivatives of sang wrt control points
    !                                     of Span
    !                   dsang_dy_inbeta - derivatives of sang wrt control points
    !                                     of in_beta*
    !                   du_dinbeta      - derivatives of u coordinates of blade
    !                                     section wrt control points of Span and in_beta*
    !                   dv_dinbeta      - derivatives of v coordinates of blade
    !                                     section wrt control points of Span and in_beta*
    !
    !-----------------------------------------------------------------------------------------------
    subroutine mprime_theta_inbeta_derivatives (mprime, theta, chrdx, chrd, sang, dchrd_dx_inbeta, dchrd_dy_inbeta, &
                                                dsang_dx_inbeta, dsang_dy_inbeta, du_dinbeta, dv_dinbeta,           &
                                                dm_dinbeta, dth_dinbeta)
        use globvar,            only: chord_switch
        use funcNsubs,          only: get_sec_number

        real,                   intent(in)      :: mprime(:)
        real,                   intent(in)      :: theta(:)
        real,                   intent(in)      :: chrdx
        real,                   intent(in)      :: chrd
        real,                   intent(in)      :: sang
        real,                   intent(in)      :: dchrd_dx_inbeta(:)
        real,                   intent(in)      :: dchrd_dy_inbeta(:)
        real,                   intent(in)      :: dsang_dx_inbeta(:)
        real,                   intent(in)      :: dsang_dy_inbeta(:)
        real,                   intent(in)      :: du_dinbeta(:,:,:)
        real,                   intent(in)      :: dv_dinbeta(:,:,:)
        real,                   intent(inout)   :: dm_dinbeta(:,:,:)
        real,                   intent(inout)   :: dth_dinbeta(:,:,:)

        ! Local variables
        integer                                 :: js, np, cpinbeta, i, j


        ! Get spanwise section index
        call get_sec_number (js)

        ! Number of points along blade section
        np                              = size(mprime)

        ! Number of control points of span (inlet flow angle)
        ! and in_beta*
        cpinbeta                        = size(dchrd_dx_inbeta)


        ! Compute derivatives
        if (chord_switch == 1) then ! non-dimensional actual chord

            do i = 1, np
                do j = 1, cpinbeta

                    ! Span (inlet flow angle) control points
                    dm_dinbeta(i, 1, j) = chrdx * ((du_dinbeta(i, 1, j) * cos(sang)) - (dv_dinbeta(i, 1, j) * sin(sang)) - &
                                                   ((theta(i)/chrdx) * dsang_dx_inbeta(j)))
                    dth_dinbeta(i, 1, j)= chrdx * ((du_dinbeta(i, 1, j) * sin(sang)) + (dv_dinbeta(i, 1, j) * cos(sang)) + &
                                                   ((mprime(i)/chrdx) * dsang_dx_inbeta(j)))

                    ! in_beta* control points
                    dm_dinbeta(i, 2, j) = chrdx * ((du_dinbeta(i, 2, j) * cos(sang)) - (dv_dinbeta(i, 2, j) * sin(sang)) - &
                                                   ((theta(i)/chrdx) * dsang_dy_inbeta(j)))
                    dth_dinbeta(i, 2, j)= chrdx * ((du_dinbeta(i, 2, j) * sin(sang)) + (dv_dinbeta(i, 2, j) * cos(sang)) + &
                                                   ((mprime(i)/chrdx) * dsang_dy_inbeta(j)))

                end do
            end do

        else    ! using internal chord or non-dimensional chord

            do i = 1, np
                do j = 1, cpinbeta

                    ! Span (inlet flow angle) control points
                    dm_dinbeta(i, 1, j) = ((mprime(i)/chrd) * dchrd_dx_inbeta(j)) + (chrd * ((du_dinbeta(i, 1, j) * &
                                           cos(sang)) - (dv_dinbeta(i, 1, j) * sin(sang)) - ((theta(i)/chrd) *      &
                                           dsang_dx_inbeta(j))))
                    dth_dinbeta(i, 1, j)= ((theta(i)/chrd) * dchrd_dx_inbeta(j)) + (chrd * ((du_dinbeta(i, 1, j) * &
                                           sin(sang)) + (dv_dinbeta(i, 1, j) * cos(sang)) + ((mprime(i)/chrd) *    &
                                           dsang_dx_inbeta(j))))

                    ! in_beta* control points
                    dm_dinbeta(i, 2, j) = ((mprime(i)/chrd) * dchrd_dy_inbeta(j)) + (chrd * ((du_dinbeta(i, 2, j) * &
                                           cos(sang)) - (dv_dinbeta(i, 2, j) * sin(sang)) - ((theta(i)/chrd) *      &
                                           dsang_dy_inbeta(j))))
                    dth_dinbeta(i, 2, j)= ((theta(i)/chrd) * dchrd_dy_inbeta(j)) + (chrd * ((du_dinbeta(i, 2, j) * &
                                           sin(sang)) + (dv_dinbeta(i, 2, j) * cos(sang)) + ((mprime(i)/chrd) *    &
                                           dsang_dy_inbeta(j))))


                end do
            end do

        end if  ! chord_switch


    end subroutine mprime_theta_inbeta_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute derivatives of the exit angle wrt the
    ! control points of Span and out_beta* specified
    ! in the 3dbgbinput file is using the deviation
    ! spline. Computed for all spanwise sections
    !
    ! Input parameters: outbeta          - exit flow angles defined in 3dbgbinput file
    !                   in_beta          - inlet metal blade angles
    !                   outbeta_xcp_ders - derivatives of outbeta wrt control points
    !                                      of Span
    !                   outbeta_ycp_ders - derivatives of outbeta wrt control points
    !                                      of out_beta*
    !
    !-----------------------------------------------------------------------------------------------
    subroutine out_beta_ders (outbeta, in_beta, outbeta_xcp_ders, outbeta_ycp_ders, &
                              out_beta_xcp_ders, out_beta_ycp_ders)

        real,                   intent(in)      :: outbeta(:)
        real,                   intent(in)      :: in_beta(:)
        real,                   intent(in)      :: outbeta_xcp_ders(:,:)
        real,                   intent(in)      :: outbeta_ycp_ders(:,:)
        real,                   intent(inout)   :: out_beta_xcp_ders(:,:)
        real,                   intent(inout)   :: out_beta_ycp_ders(:,:)

        ! Local variables
        integer                                 :: nspn, cpoutbeta, i


        ! Number of spanwise sections
        nspn                            = size(outbeta)

        ! Number of out_beta* spanwise control points
        cpoutbeta                       = size(outbeta_xcp_ders, 2)

        ! Initialize output arrays
        out_beta_xcp_ders               = 0.0
        out_beta_ycp_ders               = 0.0


        ! Compute derivatives
        do i = 1, nspn

            ! Negative camber
            if (outbeta(i) - in_beta(i) <= ZERO) then

                out_beta_xcp_ders(i,:)  = -outbeta_xcp_ders(i,:)
                out_beta_ycp_ders(i,:)  = -outbeta_ycp_ders(i,:)

            ! Positive camber
            else

                out_beta_xcp_ders(i,:)  = outbeta_xcp_ders(i,:)
                out_beta_ycp_ders(i,:)  = outbeta_ycp_ders(i,:)

            end if

        end do


    end subroutine out_beta_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of the exit angle slope
    ! wrt the control points of Span and out_beta*
    !
    ! Input parameters: dtor            - pi/180.0
    !                   out_beta        - exit angle
    !                   phi_s_out       - dr/dx = (dr/dm')/(dx/dm')
    !                   doutbeta_xcp    - derivatives of out_beta wrt Span control points
    !                   doutbeta_ycp    - derivatives of out_beta wrt out_beta* control points
    !
    !-----------------------------------------------------------------------------------------------
    subroutine sext_ders (dtor, out_beta, phi_s_out, doutbeta_dxcp, doutbeta_dycp, &
                          dsext_dxcp, dsext_dycp)
        use globvar,            only: beta_switch, cpoutbeta

        real,                   intent(in)      :: dtor
        real,                   intent(in)      :: out_beta
        real,                   intent(in)      :: phi_s_out
        real,                   intent(in)      :: doutbeta_dxcp(:)
        real,                   intent(in)      :: doutbeta_dycp(:)
        real,                   intent(inout)   :: dsext_dxcp(:)
        real,                   intent(inout)   :: dsext_dycp(:)

        ! Local variables
        integer                                 :: i


        ! Compute derivatives
        do i = 1, cpoutbeta

            ! All axial
            if (beta_switch == 0) then

                 dsext_dxcp(i)          = (dtor/(cos(dtor * out_beta))**2) * cos(phi_s_out) * doutbeta_dxcp(i)
                 dsext_dycp(i)          = (dtor/(cos(dtor * out_beta))**2) * cos(phi_s_out) * doutbeta_dycp(i)

            ! All radial
            else if (beta_switch == 1) then

                 dsext_dxcp(i)          = (dtor/(cos(dtor * out_beta))**2) * sin(phi_s_out) * doutbeta_dxcp(i)
                 dsext_dycp(i)          = (dtor/(cos(dtor * out_beta))**2) * sin(phi_s_out) * doutbeta_dycp(i)

            ! Axial IN - radial OUT
            else if (beta_switch == 2) then

                 dsext_dxcp(i)          = (dtor/(cos(dtor * out_beta))**2) * sin(phi_s_out) * doutbeta_dxcp(i)
                 dsext_dycp(i)          = (dtor/(cos(dtor * out_beta))**2) * sin(phi_s_out) * doutbeta_dycp(i)

            ! Radial IN - axial OUT
            else if (beta_switch == 3) then

                 dsext_dxcp(i)          = (dtor/(cos(dtor * out_beta))**2) * cos(phi_s_out) * doutbeta_dxcp(i)
                 dsext_dycp(i)          = (dtor/(cos(dtor * out_beta))**2) * cos(phi_s_out) * doutbeta_dycp(i)

            end if  ! beta_switch

        end do

    end subroutine sext_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of the scaling factor
    ! for mean-line second derivative wrt the control
    ! points of Span (inlet flow angle) and in_beta*
    ! specified in 3dbgbinput file
    !
    ! Input parameters: k1          - possible value of scaling factor
    !                   k2          - possible value of scaling factor
    !                   k           - scaling factor
    !                   aext        - blade exit angle
    !                   dsext_dxcp  - derivatives of tan(aext) wrt the control
    !                                 points of Span
    !                   dsext_dycp  - derivatives of tan(aext) wrt the control
    !                                 points of out_beta*
    !                   tot_cam     - total camber
    !                   P           - grouping of terms used in k quadratic equation
    !                   det         - determinant of k quadratic equation
    !
    !-----------------------------------------------------------------------------------------------
    subroutine compute_k_outbeta_ders (k1, k2, k, aext, dsext_dxcp, dsext_dycp, tot_cam, P, det, &
                                       dk_doutbeta)
        use globvar,            only: cpoutbeta

        real,                   intent(in)      :: k1
        real,                   intent(in)      :: k2
        real,                   intent(in)      :: k
        real,                   intent(in)      :: aext
        real,                   intent(in)      :: dsext_dxcp(:)
        real,                   intent(in)      :: dsext_dycp(:)
        real,                   intent(in)      :: tot_cam
        real,                   intent(in)      :: P
        real,                   intent(in)      :: det
        real,   allocatable,    intent(inout)   :: dk_doutbeta(:,:)

        ! Local variables
        real,   parameter                       :: tol = 10E-16
        integer                                 :: i
        real                                    :: dC_doutbeta(2, cpoutbeta), ddet_doutbeta(2, cpoutbeta)


        ! Allocate and initialize output arrays
        if (allocated(dk_doutbeta)) deallocate(dk_doutbeta)
        allocate(dk_doutbeta(2, cpoutbeta))

        dk_doutbeta                     = 0.0


        ! Compute derivatives of tot_cam
        do i = 1, cpoutbeta
            dC_doutbeta(1, i)           = (ONE/(ONE + (tan(aext))**2)) * dsext_dxcp(i)
            dC_doutbeta(2, i)           = (ONE/(ONE + (tan(aext))**2)) * dsext_dycp(i)
        end do


        ! Compute derivatives of determinant
        do i = 1, cpoutbeta
            ddet_doutbeta(1, i)         = (EIGHT * P/((cos(tot_cam))**2)) * tan(tot_cam) * dC_doutbeta(1, i)
            ddet_doutbeta(2, i)         = (EIGHT * P/((cos(tot_cam))**2)) * tan(tot_cam) * dC_doutbeta(2, i)
        end do


        ! Compute derivatives
        if (abs(k - k1) < tol) then ! k = k1

            do i = 1, cpoutbeta
                dk_doutbeta(1, i)       = ((ONE/(FOUR * P * tan(tot_cam) * sqrt(det))) * ddet_doutbeta(1, i)) - &
                                          ((k/(tan(tot_cam) * ((cos(tot_cam))**2))) * dC_doutbeta(1, i))
                dk_doutbeta(2, i)       = ((ONE/(FOUR * P * tan(tot_cam) * sqrt(det))) * ddet_doutbeta(2, i)) - &
                                          ((k/(tan(tot_cam) * ((cos(tot_cam))**2))) * dC_doutbeta(2, i))
            end do

        else    ! k = k2

            do i = 1, cpoutbeta
                dk_doutbeta(1, i)       = -((ONE/(FOUR * P * tan(tot_cam) * sqrt(det))) * ddet_doutbeta(1, i)) - &
                                           ((k/(tan(tot_cam) * ((cos(tot_cam))**2))) * dC_doutbeta(1, i))
                dk_doutbeta(2, i)       = -((ONE/(FOUR * P * tan(tot_cam) * sqrt(det))) * ddet_doutbeta(2, i)) - &
                                           ((k/(tan(tot_cam) * ((cos(tot_cam))**2))) * dC_doutbeta(2, i))
            end do

        end if


    end subroutine compute_k_outbeta_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute derivatives of d1v_end computed in bsplinecam.f90
    ! wrt the control points of Span and out_beta* specified in
    ! 3dbgbinput file
    !
    ! Input parameters: k           - scaling factor
    !                   d1v_end     - values of v'_m(u) at B-spline segment endpoints
    !                   dk_doutbeta - derivatives of k wrt control points of Span
    !                                 and out_beta*
    !
    !-----------------------------------------------------------------------------------------------
    subroutine d1v_end_outbeta_ders (k, d1v_end, dk_doutbeta, d1v_end_doutbeta)
        use globvar,            only: cpoutbeta

        real,                   intent(in)      :: k
        real,                   intent(in)      :: d1v_end(:)
        real,                   intent(in)      :: dk_doutbeta(:,:)
        real,   allocatable,    intent(inout)   :: d1v_end_doutbeta(:,:,:)

        ! Local variables
        integer                                 :: nseg, i, j


        ! Number of B-spline segment end points
        nseg                            = size(d1v_end)

        ! Allocate and initialize output array
        if (allocated(d1v_end_doutbeta)) deallocate(d1v_end_doutbeta)
        allocate (d1v_end_doutbeta(nseg, 2, cpoutbeta))

        d1v_end_doutbeta                = 0.0


        ! Compute derivatives
        do i = 1, nseg
            do j = 1, cpoutbeta
                d1v_end_doutbeta(i, 1, j) &
                                        = dk_doutbeta(1, j) * (d1v_end(i)/k)
                d1v_end_doutbeta(i, 2, j) &
                                        = dk_doutbeta(2, j) * (d1v_end(i)/k)
            end do
        end do


    end subroutine d1v_end_outbeta_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute derivatives of v_end computed in bsplinecam.f90
    ! wrt the control points of Span and out_beta* specified in
    ! 3dbgbinput file
    !
    ! Input parameters: k           - scaling factor
    !                   v_end       - values of v_m(u) at B-spline segment endpoints
    !                   dk_doutbeta - derivatives of k wrt control points of Span
    !                                 and out_beta*
    !
    !-----------------------------------------------------------------------------------------------
    subroutine v_end_outbeta_ders (k, v_end, dk_doutbeta, dv_end_doutbeta)
        use globvar,            only: cpoutbeta

        real,                   intent(in)      :: k
        real,                   intent(in)      :: v_end(:)
        real,                   intent(in)      :: dk_doutbeta(:,:)
        real,   allocatable,    intent(inout)   :: dv_end_doutbeta(:,:,:)

        ! Local variables
        integer                                 :: nseg, i, j


        ! Number of B-spline segment endpoints
        nseg                            = size(v_end)

        ! Allocate and initialize output array
        if (allocated(dv_end_doutbeta)) deallocate(dv_end_doutbeta)
        allocate (dv_end_doutbeta(nseg, 2, cpoutbeta))

        dv_end_doutbeta                = 0.0


        ! Compute derivatives
        do i = 1, nseg
            do j = 1, cpoutbeta
                dv_end_doutbeta(i, 1, j) &
                                        = dk_doutbeta(1, j) * (v_end(i)/k)
                dv_end_doutbeta(i, 2, j) &
                                        = dk_doutbeta(2, j) * (v_end(i)/k)
            end do
        end do


    end subroutine v_end_outbeta_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of a (u, v) section
    ! wrt the control points of Span and out_beta*
    !
    ! Input parameters: thickness        - thickness distribution values
    !                   slope            - mean-line first derivative values
    !                   dslope_doutbeta  - derivatives of v'_m(u) wrt control points
    !                                      of Span and out_beta*
    !                   dcam_doutbeta    - derivatives of v'_m(u) wrt control points
    !                                      of Span and out_beta*
    !
    !-----------------------------------------------------------------------------------------------
    subroutine uv_outbeta_derivatives (thickness, slope, dslope_doutbeta, dcam_doutbeta, &
                                      dxbot_doutbeta, dybot_doutbeta, dxtop_doutbeta, dytop_doutbeta)
        use globvar,            only: cpoutbeta
        use funcNsubs,          only: get_sec_number

        real,                   intent(in)      :: thickness(:)
        real,                   intent(in)      :: slope(:)
        real,                   intent(in)      :: dslope_doutbeta(:,:,:)
        real,                   intent(in)      :: dcam_doutbeta(:,:,:)
        real,   allocatable,    intent(inout)   :: dxbot_doutbeta(:,:,:)
        real,   allocatable,    intent(inout)   :: dybot_doutbeta(:,:,:)
        real,   allocatable,    intent(inout)   :: dxtop_doutbeta(:,:,:)
        real,   allocatable,    intent(inout)   :: dytop_doutbeta(:,:,:)

        ! Local variables
        integer                                 :: js, np, i, j


        ! Spanwise section index
        call get_sec_number (js)

        ! Number of points
        np                              = size(dslope_doutbeta, 1)

        ! Allocate and initialize output arrays
        if (allocated(dxbot_doutbeta)) deallocate(dxbot_doutbeta)
        allocate(dxbot_doutbeta(np, 2, cpoutbeta))
        if (allocated(dybot_doutbeta)) deallocate(dybot_doutbeta)
        allocate(dybot_doutbeta(np, 2, cpoutbeta))
        if (allocated(dxtop_doutbeta)) deallocate(dxtop_doutbeta)
        allocate(dxtop_doutbeta(np, 2, cpoutbeta))
        if (allocated(dytop_doutbeta)) deallocate(dytop_doutbeta)
        allocate(dytop_doutbeta(np, 2, cpoutbeta))

        dxbot_doutbeta                   = 0.0
        dybot_doutbeta                   = 0.0
        dxtop_doutbeta                   = 0.0
        dytop_doutbeta                   = 0.0


        ! Compute derivatives
        do i = 1, np
            do j = 1, cpoutbeta

                ! Span control points
                dxbot_doutbeta(i, 1, j) = ((thickness(i)/(ONE + (slope(i))**2))) * dslope_doutbeta(i, 1, j)
                dybot_doutbeta(i, 1, j) = dcam_doutbeta(i, 1, j) + &
                                          (((thickness(i) * slope(i))/(ONE + (slope(i))**2)) * dslope_doutbeta(i, 1, j))
                dxtop_doutbeta(i, 1, j) = -((thickness(i)/(ONE + (slope(i))**2))) * dslope_doutbeta(i, 1, j)
                dytop_doutbeta(i, 1, j) = dcam_doutbeta(i, 1, j) - &
                                          (((thickness(i) * slope(i))/(ONE + (slope(i))**2)) * dslope_doutbeta(i, 1, j))

                ! in_beta* control points
                dxbot_doutbeta(i, 2, j) = ((thickness(i)/(ONE + (slope(i))**2))) * dslope_doutbeta(i, 2, j)
                dybot_doutbeta(i, 2, j) = dcam_doutbeta(i, 2, j) + &
                                          (((thickness(i) * slope(i))/(ONE + (slope(i))**2)) * dslope_doutbeta(i, 2, j))
                dxtop_doutbeta(i, 2, j) = -((thickness(i)/(ONE + (slope(i))**2))) * dslope_doutbeta(i, 2, j)
                dytop_doutbeta(i, 2, j) = dcam_doutbeta(i, 2, j) - &
                                          (((thickness(i) * slope(i))/(ONE + (slope(i))**2)) * dslope_doutbeta(i, 2, j))

            end do
        end do


    end subroutine uv_outbeta_derivatives
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of a (m',theta) section
    ! wrt the control points of Span and in_beta*
    !
    ! Input parameters: mprime          - m' coordinate of blade section
    !                   theta           - theta coordinate of blade section
    !                   chrdx           - non-dimensional actual chord
    !                   chrd            - non-dimensional chord
    !                   sang            - stagger
    !                   du_doutbeta     - derivatives of u coordinates of blade
    !                                     section wrt control points of Span and out_beta*
    !                   dv_doutbeta     - derivatives of v coordinates of blade
    !                                     section wrt control points of Span and out_beta*
    !                   dsang_doutbeta  - derivatives of sang wrt control points
    !                                     of Span and out_beta*
    !                   dchrd_doutbeta  - derivatives of chrd wrt control points
    !                                     of Span and out_beta*
    !
    !-----------------------------------------------------------------------------------------------
    subroutine mprime_theta_outbeta_ders (mprime, theta, chrdx, chrd, sang, du_doutbeta, dv_doutbeta, &
                                          dsang_doutbeta, dchrd_doutbeta, dm_doutbeta, dth_doutbeta)
        use globvar,            only: chord_switch, cpoutbeta

        real,                   intent(in)      :: mprime(:)
        real,                   intent(in)      :: theta(:)
        real,                   intent(in)      :: chrdx
        real,                   intent(in)      :: chrd
        real,                   intent(in)      :: sang
        real,                   intent(in)      :: du_doutbeta(:,:,:)
        real,                   intent(in)      :: dv_doutbeta(:,:,:)
        real,                   intent(in)      :: dsang_doutbeta(:,:)
        real,                   intent(in)      :: dchrd_doutbeta(:,:)
        real,                   intent(inout)   :: dm_doutbeta(:,:,:)
        real,                   intent(inout)   :: dth_doutbeta(:,:,:)

        ! Local variables
        integer                                 :: np, i, j


        ! Number of points along blade section
        np                              = size(du_doutbeta, 1)


        ! Compute derivatives
        if (chord_switch == 1) then ! non-dimensional actual chord

            do i = 1, np
                do j = 1, cpoutbeta

                    ! Span control points
                    dm_doutbeta(i, 1, j) &
                                        = chrdx * ((du_doutbeta(i, 1, j) * cos(sang)) - (dv_doutbeta(i, 1, j) * sin(sang)) - &
                                                   ((theta(i)/chrdx) * dsang_doutbeta(1, j)))
                    dth_doutbeta(i, 1, j) &
                                        = chrdx * ((du_doutbeta(i, 1, j) * sin(sang)) + (dv_doutbeta(i, 1, j) * cos(sang)) + &
                                                   ((mprime(i)/chrdx) * dsang_doutbeta(1, j)))

                    ! out_beta* control points
                    dm_doutbeta(i, 2, j) &
                                        = chrdx * ((du_doutbeta(i, 2, j) * cos(sang)) - (dv_doutbeta(i, 2, j) * sin(sang)) - &
                                                   ((theta(i)/chrdx) * dsang_doutbeta(2, j)))
                    dth_doutbeta(i, 2, j) &
                                        = chrdx * ((du_doutbeta(i, 2, j) * sin(sang)) + (dv_doutbeta(i, 2, j) * cos(sang)) + &
                                                   ((mprime(i)/chrdx) * dsang_doutbeta(2, j)))

                end do
            end do

        else    ! non-dimensional chord or internal chord

            do i = 1, np
                do j = 1, cpoutbeta

                    ! Span control points
                    dm_doutbeta(i, 1, j) &
                                        = ((mprime(i)/chrd) * dchrd_doutbeta(1, j)) + (chrd * ((du_doutbeta(i, 1, j) * &
                                           cos(sang)) - (dv_doutbeta(i, 1, j) * sin(sang)) - ((theta(i)/chrd) *      &
                                           dsang_doutbeta(1, j))))
                    dth_doutbeta(i, 1, j) &
                                        = ((theta(i)/chrd) * dchrd_doutbeta(1, j)) + (chrd * ((du_doutbeta(i, 1, j) * &
                                           sin(sang)) + (dv_doutbeta(i, 1, j) * cos(sang)) + ((mprime(i)/chrd) *    &
                                           dsang_doutbeta(1, j))))

                    ! out_beta* control points
                    dm_doutbeta(i, 2, j) &
                                        = ((mprime(i)/chrd) * dchrd_doutbeta(2, j)) + (chrd * ((du_doutbeta(i, 2, j) * &
                                           cos(sang)) - (dv_doutbeta(i, 2, j) * sin(sang)) - ((theta(i)/chrd) *      &
                                           dsang_doutbeta(2, j))))
                    dth_doutbeta(i, 2, j) &
                                        = ((theta(i)/chrd) * dchrd_doutbeta(2, j)) + (chrd * ((du_doutbeta(i, 2, j) * &
                                           sin(sang)) + (dv_doutbeta(i, 2, j) * cos(sang)) + ((mprime(i)/chrd) *    &
                                           dsang_doutbeta(2, j))))

                end do
            end do

        end if  ! chord_switch


    end subroutine mprime_theta_outbeta_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute the derivatives of a (m',theta) section
    ! wrt the control points of Span and in_beta*
    !
    ! Input parameters: mprime          - m' coordinate of blade section
    !                   theta           - theta coordinate of blade section
    !                   chrdx           - non-dimensional actual chord
    !                   chrd            - non-dimensional chord
    !                   dchrdx_dcm      - derivatives of chrdx wrt control points
    !                                     of Span and chord_multiplier
    !                   dchrd_dcm       - derivatives of chrd wrt control points
    !                                     of Span and chord_multiplier
    !
    !-----------------------------------------------------------------------------------------------
    subroutine mprime_theta_cm_ders (mprime, theta, chrdx, chrd, dchrdx_dcm, dchrd_dcm, dm_dcm, dth_dcm)
        use globvar,            only: chord_switch, cpchord

        real,                   intent(in)      :: mprime(:)
        real,                   intent(in)      :: theta(:)
        real,                   intent(in)      :: chrdx
        real,                   intent(in)      :: chrd
        real,                   intent(in)      :: dchrdx_dcm(:,:)
        real,                   intent(in)      :: dchrd_dcm(:,:)
        real,                   intent(inout)   :: dm_dcm(:,:,:)
        real,                   intent(inout)   :: dth_dcm(:,:,:)

        ! Local variables
        integer                                 :: np, i, j


        ! Number of points along blade section
        np                              = size(mprime)


        ! Compute derivatives
        if (chord_switch == 1) then ! non-dimensional actual chord

            do i = 1, np
                do j = 1, cpchord

                    ! Span control points
                    dm_dcm(i, 1, j)     = dchrdx_dcm(1, j) * (mprime(i)/chrdx)
                    dth_dcm(i, 1, j)    = dchrdx_dcm(1, j) * (theta(i)/chrdx)

                    ! Chord_multiplier control points
                    dm_dcm(i, 2, j)     = dchrdx_dcm(2, j) * (mprime(i)/chrdx)
                    dth_dcm(i, 2, j)    = dchrdx_dcm(2, j) * (theta(i)/chrdx)

                end do
            end do

        else    ! internal chord or non-dimensional chord

            do i = 1, np
                do j = 1, cpchord

                    ! Span control points
                    dm_dcm(i, 1, j)     = dchrd_dcm(1, j) * (mprime(i)/chrd)
                    dth_dcm(i, 1, j)    = dchrd_dcm(1, j) * (theta(i)/chrd)

                    ! Chord_multiplier control points
                    dm_dcm(i, 2, j)     = dchrd_dcm(2, j) * (mprime(i)/chrd)
                    dth_dcm(i, 2, j)    = dchrd_dcm(2, j) * (theta(i)/chrd)

                end do
            end do

        end if  ! chord_switch


    end subroutine mprime_theta_cm_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Differentiate function spl_eval defined in funcNsubs
    ! wrt the input parameter tt. This subroutine is used
    ! to compute the derivatives of (x, r) for a blade
    ! section wrt all the input parameters.
    !
    ! Input parameters: n       - number of spline values
    !                   tt      - t value at which spline is to be evaluated
    !                   y       - dependent variable values
    !                   dydt    - knot first derivatives
    !                   t       - independent variable values
    !                   tt_ders - derivatives of tt wrt T-Blade3 parameters
    !                             (for x and r, tt = m'_3D)
    !
    !-----------------------------------------------------------------------------------------------
    subroutine spl_eval_ders (n, tt, y, dydt, t, tt_ders, out_ders)

        integer,                intent(in)      :: n
        real,                   intent(in)      :: tt
        real,                   intent(in)      :: y(n)
        real,                   intent(in)      :: dydt(n)
        real,                   intent(in)      :: t(n)
        real,                   intent(in)      :: tt_ders(:,:)
        real,                   intent(inout)   :: out_ders(:,:)

        ! Local variables
        integer                                 :: nparams, ncp, knt1, knt2, i, j
        real                                    :: dt, dy, dt2, frac, a(4), temp1, temp2, temp3, temp4
        real,   parameter                       :: tol = 10E-16
        real,   allocatable                     :: dt2_ders(:,:), frac_ders(:,:)


        ! Array dimensions
        nparams                         = size(tt_ders, 1)  ! Number of parameters
        ncp                             = size(tt_ders, 2)  ! Number of spanwise control points


        ! Computing spl_eval
        knt1                            = find_knt_copy(tt, t, n)
        knt2                            = knt1 + 1

        dt                              = t(knt2) - t(knt1)
        dy                              = y(knt2) - y(knt1)
        dt2                             = tt - t(knt1)
        frac                            = dt2/dt

        a(1)                            = y(knt1)
        a(2)                            = dydt(knt1)
        a(3)                            = (THREE * dy * (frac**2)) - ((dydt(knt2) + &
                                          (TWO * dydt(knt1))) * frac * dt2)
        a(4)                            = (-TWO * dy * (frac**3)) + ((dydt(knt2) + dydt(knt1)) * (frac**2) * dt2)


        ! Allocate arrays to store derivatives of dt2 and frac
        if (allocated(dt2_ders)) deallocate(dt2_ders)
        allocate(dt2_ders(nparams, ncp))
        if (allocated(frac_ders)) deallocate(frac_ders)
        allocate(frac_ders(nparams, ncp))

        ! Compute derivatives of dt2 and frac
        do i = 1, nparams
            do j = 1, ncp
                dt2_ders(i, j)          = tt_ders(i, j)
                frac_ders(i, j)         = (ONE/dt) * tt_ders(i, j)
            end do
        end do


        ! Compute out_ders
        do i = 1, nparams
            do j = 1, ncp

                if (abs(tt - t(knt1)) < tol) then   ! spl_eval = a(1)
                    out_ders(i, j)      = ZERO
                else
                    temp1               = SIX * dy * frac * frac_ders(i, j)
                    temp2               = (dydt(knt2) + (TWO * dydt(knt1))) * ((frac_ders(i, j) * dt2) + &
                                                                               (frac * dt2_ders(i, j)))
                    temp3               = SIX * dy * (frac**2) * frac_ders(i, j)
                    temp4               = (dydt(knt2) + dydt(knt1)) * ((TWO * frac * dt2 * frac_ders(i, j)) + &
                                                                       ((frac**2) * dt2_ders(i, j)))
                    out_ders(i, j)      = (a(2) * dt2_ders(i, j)) + temp1 - temp2 - temp3 + temp4
                end if

            end do
        end do


    end subroutine spl_eval_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute derivatives of (y, z) for a point along
    ! a blade section with respect to all control points
    ! of Span and delta_m
    !
    ! Input parameters: theta       - theta value at the given point
    !                   deltheta    - value of lean at the given point
    !                   dr_dsweep   - derivatives of 'r' at the given point
    !
    !-----------------------------------------------------------------------------------------------
    subroutine yz_sweep_ders (theta, deltheta, dr_dsweep, dy_dsweep, dz_dsweep)

        real,                   intent(in)      :: theta
        real,                   intent(in)      :: deltheta
        real,                   intent(in)      :: dr_dsweep(:,:)
        real,                   intent(inout)   :: dy_dsweep(:,:)
        real,                   intent(inout)   :: dz_dsweep(:,:)

        ! Local variables
        integer                                 :: nparams, ncp, i, j


        ! Array sizes
        nparams                         = size(dr_dsweep, 1)
        ncp                             = size(dr_dsweep, 2)


        ! Compute derivatives
        do i = 1, nparams
            do j = 1, ncp
                dy_dsweep(i, j)         = dr_dsweep(i, j) * (sin(theta + deltheta))
                dz_dsweep(i, j)         = dr_dsweep(i, j) * (cos(theta + deltheta))
            end do
        end do


    end subroutine yz_sweep_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute derivatives of (y, z) at a point along a
    ! blade section wrt control points of Span and
    ! delta_theta
    !
    ! Input parameters: r               - r value at the given point
    !                   theta           - theta value at the given point
    !                   deltheta        - delta_theta value at the given point
    !                   deltheta_xcp    - derivative of spanwise value of delta_theta
    !                                     wrt spanwise control points of Span
    !                   deltheta_xcp    - derivative of spanwise value of delta_theta
    !                                     wrt spanwise control points of delta_theta
    !
    !-----------------------------------------------------------------------------------------------
    subroutine yz_lean_ders (r, theta, deltheta, deltheta_xcp, deltheta_ycp, dy_dlean, dz_dlean)

        real,                   intent(in)      :: r
        real,                   intent(in)      :: theta
        real,                   intent(in)      :: deltheta
        real,                   intent(in)      :: deltheta_xcp(:)
        real,                   intent(in)      :: deltheta_ycp(:)
        real,                   intent(inout)   :: dy_dlean(:,:)
        real,                   intent(inout)   :: dz_dlean(:,:)

        ! Local variables
        integer                                 :: ncp, i


        ! Number of spanwise control points
        ncp                             = size(deltheta_xcp)


        ! Compute derivatives
        do i = 1, ncp
            dy_dlean(1, i)              = r * cos(theta + deltheta) * deltheta_xcp(i)
            dy_dlean(2, i)              = r * cos(theta + deltheta) * deltheta_ycp(i)
            dz_dlean(1, i)              = -r * sin(theta + deltheta) * deltheta_xcp(i)
            dz_dlean(2, i)              = -r * sin(theta + deltheta) * deltheta_ycp(i)
        end do


    end subroutine yz_lean_ders
    !-----------------------------------------------------------------------------------------------






    !
    ! Compute derivatives of (y, z) at a point along a
    ! blade section wrt control points of all parameters
    ! except sweep and lean
    !
    ! Input parameters: r           - r value at the given point
    !                   theta       - theta value at the given point
    !                   deltheta    - delta_theta value at the given point
    !                   dr_dp       - derivatives of r at the given point
    !                   dth_dp      - derivatives of theta at the given point
    !
    !-----------------------------------------------------------------------------------------------
    subroutine yz_param_ders (r, theta, deltheta, dr_dp, dth_dp, dy_dp, dz_dp)

        real,                   intent(in)      :: r
        real,                   intent(in)      :: theta
        real,                   intent(in)      :: deltheta
        real,                   intent(in)      :: dr_dp(:,:)
        real,                   intent(in)      :: dth_dp(:,:)
        real,                   intent(inout)   :: dy_dp(:,:)
        real,                   intent(inout)   :: dz_dp(:,:)

        ! Local variables
        integer                                 :: nparams, ncp, i, j


        ! Array sizes
        nparams                         = size(dr_dp, 1)
        ncp                             = size(dr_dp, 2)


        ! Compute derivatives
        do i = 1, nparams
            do j = 1, ncp
                dy_dp(i, j)             = (dr_dp(i, j) * sin(theta + deltheta)) + (r * cos(theta + deltheta) * dth_dp(i, j))
                dz_dp(i, j)             = (dr_dp(i, j) * cos(theta + deltheta)) - (r * sin(theta + deltheta) * dth_dp(i, j))
            end do
        end do


    end subroutine yz_param_ders
    !-----------------------------------------------------------------------------------------------




















end module derivatives
