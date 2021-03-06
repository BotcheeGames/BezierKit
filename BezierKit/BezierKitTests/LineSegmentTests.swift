//
//  LineSegmentTests.swift
//  BezierKit
//
//  Created by Holmes Futrell on 5/14/17.
//  Copyright © 2017 Holmes Futrell. All rights reserved.
//

import XCTest
@testable import BezierKit

class LineSegmentTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitializerArray() {
        let l = LineSegment(points: [CGPoint(x: 1.0, y: 1.0), CGPoint(x: 3.0, y: 2.0)])
        XCTAssertEqual(l.p0, CGPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(l.p1, CGPoint(x: 3.0, y: 2.0))
        XCTAssertEqual(l.startingPoint, CGPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(l.endingPoint, CGPoint(x: 3.0, y: 2.0))
    }

    func testInitializerIndividualPoints() {
        let l = LineSegment(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 3.0, y: 2.0))
        XCTAssertEqual(l.p0, CGPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(l.p1, CGPoint(x: 3.0, y: 2.0))
        XCTAssertEqual(l.startingPoint, CGPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(l.endingPoint, CGPoint(x: 3.0, y: 2.0))
    }
    
    func testBasicProperties() {
        let l = LineSegment(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 2.0, y: 5.0))
        XCTAssert(l.simple)
        XCTAssertEqual(l.order, 1)
        XCTAssertEqual(l.startingPoint, CGPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(l.endingPoint, CGPoint(x: 2.0, y: 5.0))
    }
    
    func testSetStartEndPoints() {
        var l = LineSegment(p0: CGPoint(x: 5.0, y: 6.0), p1: CGPoint(x: 8.0, y: 7.0))
        l.startingPoint = CGPoint(x: 4.0, y: 5.0)
        XCTAssertEqual(l.p0, l.startingPoint)
        XCTAssertEqual(l.startingPoint, CGPoint(x: 4.0, y: 5.0))
        l.endingPoint = CGPoint(x: 9.0, y: 8.0)
        XCTAssertEqual(l.p1, l.endingPoint)
        XCTAssertEqual(l.endingPoint, CGPoint(x: 9.0, y: 8.0))
    }
    
    func testDerivative() {
        let l = LineSegment(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 3.0, y: 2.0))
        XCTAssertEqual(l.derivative(0.23), CGPoint(x: 2.0, y: 1.0))
    }
    
    func testSplitFromTo() {
        let l = LineSegment(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 4.0, y: 7.0))
        let t1: CGFloat = 1.0 / 3.0
        let t2: CGFloat = 2.0 / 3.0
        let s = l.split(from: t1, to: t2)
        XCTAssertEqual(s, LineSegment(p0: CGPoint(x: 2.0, y: 3.0), p1: CGPoint(x: 3.0, y: 5.0)))
    }
    
    func testSplitAt() {
        let l = LineSegment(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 3.0, y: 5.0))
        let (left, right) = l.split(at: 0.5)
        XCTAssertEqual(left, LineSegment(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 2.0, y: 3.0)))
        XCTAssertEqual(right, LineSegment(p0: CGPoint(x: 2.0, y: 3.0), p1: CGPoint(x: 3.0, y: 5.0)))
    }
    
    func testBoundingBox() {
        let l = LineSegment(p0: CGPoint(x: 3.0, y: 5.0), p1: CGPoint(x: 1.0, y: 3.0))
        XCTAssertEqual(l.boundingBox, BoundingBox(p1: CGPoint(x: 1.0, y: 3.0), p2: CGPoint(x: 3.0, y: 5.0)))
    }
    
    func testCompute() {
        let l = LineSegment(p0: CGPoint(x: 3.0, y: 5.0), p1: CGPoint(x: 1.0, y: 3.0))
        XCTAssertEqual(l.compute(0.0), CGPoint(x: 3.0, y: 5.0))
        XCTAssertEqual(l.compute(0.5), CGPoint(x: 2.0, y: 4.0))
        XCTAssertEqual(l.compute(1.0), CGPoint(x: 1.0, y: 3.0))
    }
    
    func testLength() {
        let l = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 4.0, y: 6.0))
        XCTAssertEqual(l.length(), 5.0)
    }
    
    func testExtrema() {
        let l = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 4.0, y: 6.0))
        let (xyz, values) = l.extrema()
        XCTAssertTrue(xyz.isEmpty)
        XCTAssertTrue(values.isEmpty)
    }
    
    func testHull() {
        let l = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 3.0, y: 4.0))
        let h = l.hull(0.5)
        XCTAssert(h.count == 3)
        XCTAssertEqual(h[0], CGPoint(x: 1.0, y: 2.0))
        XCTAssertEqual(h[1], CGPoint(x: 3.0, y: 4.0))
        XCTAssertEqual(h[2], CGPoint(x: 2.0, y: 3.0))
    }
    
    func testNormal() {
        let l = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 5.0, y: 6.0))
        let n1 = l.normal(0.0)
        let n2 = l.normal(0.5)
        let n3 = l.normal(1.0)
        XCTAssertEqual(n1, CGPoint(x: -1.0 / sqrt(2.0), y: 1.0 / sqrt(2.0)))
        XCTAssertEqual(n1, n2)
        XCTAssertEqual(n2, n3)
    }
    
    func testReduce() {
        let l = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 5.0, y: 6.0))
        let r = l.reduce() // reduce should just return the original line back
        XCTAssertEqual(r.count, 1)
        XCTAssertEqual(r[0].t1, 0.0)
        XCTAssertEqual(r[0].t2, 1.0)
        XCTAssertEqual(r[0].curve, l)
    }

    func testSelfIntersects() {
        let l = LineSegment(p0: CGPoint(x: 3.0, y: 4.0), p1: CGPoint(x: 5.0, y: 6.0))
        XCTAssertFalse(l.selfIntersects()) // lines never self-intersect
    }

    func testSelfIntersections() {
        let l = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 5.0, y: 6.0))
        XCTAssert(l.selfIntersections().count == 0) // lines never self-intersect
    }

    // -- MARK: - line-line intersection tests
    
    func testIntersectionsLineYesInsideInterval() {
        // a normal line-line intersection that happens in the middle of a line
        let l1 = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 7.0, y: 8.0))
        let l2 = LineSegment(p0: CGPoint(x: 1.0, y: 4.0), p1: CGPoint(x: 5.0, y: 0.0))
        let i = l1.intersections(with: l2)
        XCTAssertEqual(i.count, 1)
        XCTAssertEqual(i[0].t1, 1.0 / 6.0)
        XCTAssertEqual(i[0].t2, 1.0 / 4.0)
    }
    
    func testIntersectionsLineNoOutsideInterval1() {
        // two lines that do not intersect because the intersection happens outside the line-segment
        let l1 = LineSegment(p0: CGPoint(x: 1.0, y: 0.0), p1: CGPoint(x: 1.0, y: 2.0))
        let l2 = LineSegment(p0: CGPoint(x: 0.0, y: 2.001), p1: CGPoint(x: 2.0, y: 2.001))
        let i = l1.intersections(with: l2)
        XCTAssert(i.isEmpty)
    }
    
    func testIntersectionsLineNoOutsideInterval2() {
        // two lines that do not intersect because the intersection happens outside the *other* line segment
        let l1 = LineSegment(p0: CGPoint(x: 1.0, y: 0.0), p1: CGPoint(x: 1.0, y: 2.0))
        let l2 = LineSegment(p0: CGPoint(x: 2.0, y: 1.0), p1: CGPoint(x: 1.001, y: 1.0))
        let i = l1.intersections(with: l2)
        XCTAssert(i.isEmpty)
    }
    
    func testIntersectionsLineYesEdge1() {
        // two lines that intersect on the 1st line's edge
        let l1 = LineSegment(p0: CGPoint(x: 1.0, y: 0.0), p1: CGPoint(x: 1.0, y: 2.0))
        let l2 = LineSegment(p0: CGPoint(x: 2.0, y: 1.0), p1: CGPoint(x: 1.0, y: 1.0))
        let i = l1.intersections(with: l2)
        XCTAssertEqual(i.count, 1)
        XCTAssertEqual(i[0].t1, 0.5)
        XCTAssertEqual(i[0].t2, 1.0)
    }
    
    func testIntersectionsLineYesEdge2() {
        // two lines that intersect on the 2nd line's edge
        let l1 = LineSegment(p0: CGPoint(x: 1.0, y: 0.0), p1: CGPoint(x: 1.0, y: 2.0))
        let l2 = LineSegment(p0: CGPoint(x: 0.0, y: 2.0), p1: CGPoint(x: 2.0, y: 2.0))
        let i = l1.intersections(with: l2)
        XCTAssertEqual(i.count, 1)
        XCTAssertEqual(i[0].t1, 1.0)
        XCTAssertEqual(i[0].t2, 0.5)
    }

    func testIntersectionsLineYesLineStart() {
        // two lines that intersect at the start of the first line
        let l1 = LineSegment(p0: CGPoint(x: 1.0, y: 0.0), p1: CGPoint(x: 2.0, y: 1.0))
        let l2 = LineSegment(p0: CGPoint(x: -2.0, y: 2.0), p1: CGPoint(x: 1.0, y: 0.0))
        let i = l1.intersections(with: l2)
        XCTAssertEqual(i.count, 1)
        XCTAssertEqual(i[0].t1, 0.0)
        XCTAssertEqual(i[0].t2, 1.0)
    }
    
    func testIntersectionsLineYesLineEnd() {
        // two lines that intersect at the end of the first line
        let l1 = LineSegment(p0: CGPoint(x: 1.0, y: 0.0), p1: CGPoint(x: 2.0, y: 1.0))
        let l2 = LineSegment(p0: CGPoint(x: 2.0, y: 1.0), p1: CGPoint(x: -2.0, y: 2.0))
        let i = l1.intersections(with: l2)
        XCTAssertEqual(i.count, 1)
        XCTAssertEqual(i[0].t1, 1.0)
        XCTAssertEqual(i[0].t2, 0.0)
    }
    
    func testIntersectionsLineAsCurve() {
        // ensure that intersects(curve:) calls into the proper implementation
        let l1: LineSegment = LineSegment(p0: CGPoint(x: 0.0, y: 0.0), p1: CGPoint(x: 1.0, y: 1.0))
        let l2: BezierCurve = LineSegment(p0: CGPoint(x: 0.0, y: 1.0), p1: CGPoint(x: 1.0, y: 0.0)) as BezierCurve
        let i1 = l1.intersections(with: l2)
        XCTAssertEqual(i1.count, 1)
        XCTAssertEqual(i1[0].t1, 0.5)
        XCTAssertEqual(i1[0].t2, 0.5)
        
        let i2 = l2.intersections(with: l1)
        XCTAssertEqual(i2.count, 1)
        XCTAssertEqual(i2[0].t1, 0.5)
        XCTAssertEqual(i2[0].t2, 0.5)
    }
    
    func testIntersectionsLineNoParallel() {
        
        // this is a special case where determinant is zero
        let l1 = LineSegment(p0: CGPoint(x: -2.0, y: -1.0), p1: CGPoint(x: 2.0, y: 1.0))
        let l2 = LineSegment(p0: CGPoint(x: -4.0, y: -1.0), p1: CGPoint(x: 4.0, y: 3.0))
        let i1 = l1.intersections(with: l2)
        XCTAssertTrue(i1.isEmpty)

        // this is a very, very special case! Not only is the determinant zero, but the *minor* determinants are also zero, so without special care we can get 0*(1/det) = 0*Inf = NaN!
        let l3 = LineSegment(p0: CGPoint(x: -5.0, y: -5.0), p1: CGPoint(x: 5.0, y: 5.0))
        let l4 = LineSegment(p0: CGPoint(x: -1.0, y: -1.0), p1: CGPoint(x: 1.0, y: 1.0))
        let i2 = l3.intersections(with: l4)
        XCTAssertTrue(i2.isEmpty)

        // very, very nearly parallel lines
        let l5 = LineSegment(p0: CGPoint(x: 0.0, y: 0.0), p1: CGPoint(x: 1.0, y: 1.0))
        let l6 = LineSegment(p0: CGPoint(x: 0.0, y: 1.0), p1: CGPoint(x: 1.0, y: 2.0 + 1.0e-15))
        let i3 = l5.intersections(with: l6)
        XCTAssertTrue(i3.isEmpty)
    }
    
    // -- MARK: - line-curve intersection tests
    
    func testIntersectionsQuadratic() {
        // we mostly just care that we call into the proper implementation and that the results are ordered correctly
        // q is a quadratic where y(x) = 2 - 2(x-1)^2
        let epsilon: CGFloat = 0.00001
        let q: QuadraticBezierCurve = QuadraticBezierCurve(start: CGPoint(x: 0.0, y: 0.0),
                                                            end: CGPoint(x: 2.0, y: 0.0),
                                                            mid: CGPoint(x: 1.0, y: 2.0),
                                                                t: 0.5)
        let l1: LineSegment = LineSegment(p0: CGPoint(x: -1.0, y: 1.0), p1: CGPoint(x: 3.0, y: 1.0))
        let l2: LineSegment = LineSegment(p0: CGPoint(x: 3.0, y: 1.0), p1: CGPoint(x: -1.0, y: 1.0)) // same line as l1, but reversed
        // the intersections for both lines occur at x = 1±sqrt(1/2)
        let i1 = l1.intersections(with: q)
        let r1: CGFloat = 1.0 - sqrt(1.0 / 2.0)
        let r2: CGFloat = 1.0 + sqrt(1.0 / 2.0)
        XCTAssertEqual(i1.count, 2)
        XCTAssertEqual(i1[0].t1, (r1 + 1.0) / 4.0, accuracy: epsilon)
        XCTAssertEqual(i1[0].t2, r1 / 2.0, accuracy: epsilon)
        XCTAssert((l1.compute(i1[0].t1) - q.compute(i1[0].t2)).length < epsilon)
        XCTAssertEqual(i1[1].t1, (r2 + 1.0) / 4.0, accuracy: epsilon)
        XCTAssertEqual(i1[1].t2, r2 / 2.0, accuracy: epsilon)
        XCTAssert((l1.compute(i1[1].t1) - q.compute(i1[1].t2)).length < epsilon)
        // do the same thing as above but using l2
        let i2 = l2.intersections(with: q)
        XCTAssertEqual(i2.count, 2)
        XCTAssertEqual(i2[0].t1, (r1 + 1.0) / 4.0, accuracy: epsilon)
        XCTAssertEqual(i2[0].t2, r2 / 2.0, accuracy: epsilon)
        XCTAssert((l2.compute(i2[0].t1) - q.compute(i2[0].t2)).length < epsilon)
        XCTAssertEqual(i2[1].t1, (r2 + 1.0) / 4.0, accuracy: epsilon)
        XCTAssertEqual(i2[1].t2, r1 / 2.0, accuracy: epsilon)
        XCTAssert((l2.compute(i2[1].t1) - q.compute(i2[1].t2)).length < epsilon)
    }
    
    func testIntersectionsQuadraticSpecialCase() {
        // this is case that failed in the real-world
        let l = LineSegment(p0: CGPoint(x: -1, y: 0), p1: CGPoint(x: 1, y: 0))
        let q = QuadraticBezierCurve(p0: CGPoint(x: 0, y: 0), p1: CGPoint(x: -1, y: 0), p2: CGPoint(x: -1, y: 1))
        let i = l.intersections(with: q)
        XCTAssertEqual(i.count, 1)
        XCTAssertEqual(i.first?.t1, 0.5)
        XCTAssertEqual(i.first?.t2, 0)
    }
    
    func testIntersectionsCubic() {
        // we mostly just care that we call into the proper implementation and that the results are ordered correctly
        let epsilon: CGFloat = 0.00001
        let c: CubicBezierCurve = CubicBezierCurve(p0: CGPoint(x: -1, y: 0),
                                                   p1: CGPoint(x: -1, y: 1),
                                                   p2: CGPoint(x:  1, y: -1),
                                                   p3: CGPoint(x:  1, y: 0))
        let l1: LineSegment = LineSegment(p0: CGPoint(x: -2.0, y: 0.0), p1: CGPoint(x: 2.0, y: 0.0))
        let i1 = l1.intersections(with: c)
      
        XCTAssertEqual(i1.count, 3)
        XCTAssertEqual(i1[0].t1, 0.25, accuracy: epsilon)
        XCTAssertEqual(i1[0].t2, 0.0, accuracy: epsilon)
        XCTAssertEqual(i1[1].t1, 0.5, accuracy: epsilon)
        XCTAssertEqual(i1[1].t2, 0.5, accuracy: epsilon)
        XCTAssertEqual(i1[2].t1, 0.75, accuracy: epsilon)
        XCTAssertEqual(i1[2].t2, 1.0, accuracy: epsilon)
        // l2 is the same line going in the opposite direction
        // by checking this we ensure the intersections are ordered by the line and not the cubic
        let l2: LineSegment = LineSegment(p0: CGPoint(x: 2.0, y: 0.0), p1: CGPoint(x: -2.0, y: 0.0))
        let i2 = l2.intersections(with: c)
        XCTAssertEqual(i2.count, 3)
        XCTAssertEqual(i2[0].t1, 0.25, accuracy: epsilon)
        XCTAssertEqual(i2[0].t2, 1.0, accuracy: epsilon)
        XCTAssertEqual(i2[1].t1, 0.5, accuracy: epsilon)
        XCTAssertEqual(i2[1].t2, 0.5, accuracy: epsilon)
        XCTAssertEqual(i2[2].t1, 0.75, accuracy: epsilon)
        XCTAssertEqual(i2[2].t2, 0.0, accuracy: epsilon)
    }
        
    func testIntersectionsDegenerateCubic1() {
        // a special case where the cubic is degenerate (it can actually be described as a quadratic)
        let epsilon: CGFloat = 0.00001
        let fiveThirds: CGFloat = 5.0 / 3.0
        let sevenThirds: CGFloat = 7.0 / 3.0
        let c: CubicBezierCurve = CubicBezierCurve(p0: CGPoint(x: 1.0, y: 1.0),
                                                   p1: CGPoint(x: fiveThirds, y: fiveThirds),
                                                   p2: CGPoint(x: sevenThirds, y: fiveThirds),
                                                   p3: CGPoint(x: 3.0, y: 1.0))
        let l = LineSegment(p0: CGPoint(x:1.0, y: 1.1), p1: CGPoint(x: 3.0, y: 1.1))
        let i = l.intersections(with: c)
        XCTAssertEqual(i.count, 2)
        XCTAssert(BezierKitTestHelpers.intersections(i, betweenCurve: l, andOtherCurve: c, areWithinTolerance: epsilon))
    }
    
    func testIntersectionsDegenerateCubic2() {
        // a special case where the cubic is degenerate (it can actually be described as a line)
        let epsilon: CGFloat = 0.00001
        let c: CubicBezierCurve = CubicBezierCurve(p0: CGPoint(x: 1.0, y: 1.0),
                                                   p1: CGPoint(x: 2.0, y: 2.0),
                                                   p2: CGPoint(x: 3.0, y: 3.0),
                                                   p3: CGPoint(x: 4.0, y: 4.0))
        let l = LineSegment(p0: CGPoint(x:1.0, y: 2.0), p1: CGPoint(x: 4.0, y: 2.0))
        let i = l.intersections(with: c)
        XCTAssertEqual(i.count, 1)
        XCTAssert(BezierKitTestHelpers.intersections(i, betweenCurve: l, andOtherCurve: c, areWithinTolerance: epsilon))
    }

    func testIntersectionsCubicSpecialCase() {
        // this is case that failed in the real-world
        let l = LineSegment(p0: CGPoint(x: -1, y: 0), p1: CGPoint(x: 1, y: 0))
        let q = CubicBezierCurve(quadratic: QuadraticBezierCurve(p0: CGPoint(x: 0, y: 0), p1: CGPoint(x: -1, y: 0), p2: CGPoint(x: -1, y: 1)))
        let i = l.intersections(with: q)
        XCTAssertEqual(i.count, 1)
        XCTAssertEqual(i.first?.t1, 0.5)
        XCTAssertEqual(i.first?.t2, 0)
    }
    
    func testIntersectionsCubicRootsEdgeCase() {
        // this data caused issues in practice because because 'd' in the roots calculation is very near, but not exactly, zero.
        let c = CubicBezierCurve(p0: CGPoint(x: 201.48419096574196, y: 570.7720830272123),
                                 p1: CGPoint(x: 202.27135851996428, y: 570.7720830272123),
                                 p2: CGPoint(x: 202.90948390468964, y: 571.4102084119377),
                                 p3: CGPoint(x: 202.90948390468964, y: 572.1973759661599))
        let l = LineSegment(p0: CGPoint(x: 200.05889802679428, y: 572.1973759661599), p1: CGPoint(x: 201.48419096574196, y: 573.6226689051076))
        let i = l.intersections(with: c)
        XCTAssertEqual(i, [])
    }
    
    // MARK: -
    
    func testEquatable() {
        let l1 = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 3.0, y: 4.0))
        let l2 = LineSegment(p0: CGPoint(x: 1.0, y: 3.0), p1: CGPoint(x: 3.0, y: 4.0))
        let l3 = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 3.0, y: 5.0))
        XCTAssertEqual(l1, l1)
        XCTAssertNotEqual(l1, l2)
        XCTAssertNotEqual(l1, l3)
    }
}
