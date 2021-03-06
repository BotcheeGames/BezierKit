//
//  CubicBezierCurveTests.swift
//  BezierKit
//
//  Created by Holmes Futrell on 5/23/17.
//  Copyright © 2017 Holmes Futrell. All rights reserved.
//

import XCTest
@testable import BezierKit

class CubicBezierCurveTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitializerArray() {
        let c = CubicBezierCurve(points: [CGPoint(x: 1.0, y: 1.0), CGPoint(x: 3.0, y: 2.0), CGPoint(x: 5.0, y: 3.0), CGPoint(x: 7.0, y: 4.0)])
        XCTAssertEqual(c.p0, CGPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(c.p1, CGPoint(x: 3.0, y: 2.0))
        XCTAssertEqual(c.p2, CGPoint(x: 5.0, y: 3.0))
        XCTAssertEqual(c.p3, CGPoint(x: 7.0, y: 4.0))
        XCTAssertEqual(c.startingPoint, CGPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(c.endingPoint, CGPoint(x: 7.0, y: 4.0))
    }
    
    func testInitializerIndividualPoints() {
        let c = CubicBezierCurve(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 3.0, y: 2.0), p2: CGPoint(x: 5.0, y: 3.0), p3: CGPoint(x: 7.0, y: 4.0))
        XCTAssertEqual(c.p0, CGPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(c.p1, CGPoint(x: 3.0, y: 2.0))
        XCTAssertEqual(c.p2, CGPoint(x: 5.0, y: 3.0))
        XCTAssertEqual(c.p3, CGPoint(x: 7.0, y: 4.0))
        XCTAssertEqual(c.startingPoint, CGPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(c.endingPoint, CGPoint(x: 7.0, y: 4.0))
    }
    
    func testInitializerLineSegment() {
        let l = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 2.0, y: 3.0))
        let c = CubicBezierCurve(lineSegment: l)
        XCTAssertEqual(c.p0, l.p0)
        let oneThird: CGFloat = 1.0 / 3.0
        let twoThirds: CGFloat = 2.0 / 3.0
        XCTAssertEqual(c.p1, twoThirds * l.p0 + oneThird * l.p1)
        XCTAssertEqual(c.p2, oneThird * l.p0 + twoThirds * l.p1)
        XCTAssertEqual(c.p3, l.p1)
    }
    
    func testInitializerQuadratic() {
        let q = QuadraticBezierCurve(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 2.0, y: 2.0), p2: CGPoint(x: 3.0, y: 1.0))
        let c = CubicBezierCurve(quadratic: q)
        let epsilon: CGFloat = 1.0e-6
        // check for equality via lookup table
        let steps = 10
        for (p1, p2) in zip(q.generateLookupTable(withSteps: steps), c.generateLookupTable(withSteps: steps)) {
            XCTAssert((p1 - p2).length < epsilon)
        }
        // check for proper values in control points
        let fiveThirds: CGFloat = 5.0 / 3.0
        let sevenThirds: CGFloat = 7.0 / 3.0
        XCTAssert((c.p0 - CGPoint(x: 1.0, y: 1.0)).length < epsilon)
        XCTAssert((c.p1 - CGPoint(x: fiveThirds, y: fiveThirds)).length < epsilon)
        XCTAssert((c.p2 - CGPoint(x: sevenThirds, y: fiveThirds)).length < epsilon)
        XCTAssert((c.p3 - CGPoint(x: 3.0, y: 1.0)).length < epsilon)
    }
    
    func testInitializerStartEndMidTStrutLength() {
        
        let epsilon: CGFloat = 0.00001
        
        let start = CGPoint(x: 1.0, y: 1.0)
        let mid = CGPoint(x: 2.0, y: 2.0)
        let end = CGPoint(x: 4.0, y: 0.0)
        
        // first test passing without passing a t or d paramter
        var c = CubicBezierCurve(start: start, end: end, mid: mid)
        XCTAssertEqual(c.compute(0.0), start)
        XCTAssert((c.compute(0.5) - mid).length < epsilon)
        XCTAssertEqual(c.compute(1.0), end)
       
        // now test passing in a manual t and length d
        let t: CGFloat = 7.0 / 9.0
        let d: CGFloat = 1.5
        c = CubicBezierCurve(start: start, end: end, mid: mid, t: t, d: d)
        XCTAssertEqual(c.compute(0.0), start)
        XCTAssert((c.compute(t) - mid).length < epsilon)
        XCTAssertEqual(c.compute(1.0), end)
        // make sure our solution has the proper strut length
        let e1 = c.hull(t)[7]
        let e2 = c.hull(t)[8]
        let l = (e2 - e1).length
        XCTAssertEqual(l, d * 1.0 / t, accuracy: epsilon)
    }
    
    func testBasicProperties() {
        let c = CubicBezierCurve(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 3.0, y: 2.0), p2: CGPoint(x: 4.0, y: 2.0), p3: CGPoint(x: 6.0, y: 1.0))
        XCTAssert(c.simple)
        XCTAssertEqual(c.order, 3)
        XCTAssertEqual(c.startingPoint, CGPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(c.endingPoint, CGPoint(x: 6.0, y: 1.0))
    }

    func testSetStartEndPoints() {
        var c = CubicBezierCurve(p0: CGPoint(x: 5.0, y: 6.0), p1: CGPoint(x: 6.0, y: 5.0), p2: CGPoint(x: 7.0, y: 8.0), p3: CGPoint(x: 8.0, y: 7.0))
        c.startingPoint = CGPoint(x: 4.0, y: 5.0)
        XCTAssertEqual(c.p0, c.startingPoint)
        XCTAssertEqual(c.startingPoint, CGPoint(x: 4.0, y: 5.0))
        c.endingPoint = CGPoint(x: 9.0, y: 8.0)
        XCTAssertEqual(c.p3, c.endingPoint)
        XCTAssertEqual(c.endingPoint, CGPoint(x: 9.0, y: 8.0))
    }
    
    func testSimple() {
        // create a simple cubic curve (very simple, because it's equal to a line segment)
        let c1 = CubicBezierCurve(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 2.0, y: 2.0), p2: CGPoint(x: 3.0, y: 3.0), p3: CGPoint(x: 4.0, y: 4.0))
        XCTAssert(c1.simple == true)
        // a non-trivial example of a simple curve -- almost a straight line
        let c2 = CubicBezierCurve(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 2.0, y: 1.05), p2: CGPoint(x: 3.0, y: 1.05), p3: CGPoint(x: 4.0, y: 1.0))
        XCTAssert(c2.simple == true)
        // non-simple curve, control points fall on different sides of the baseline
        let c3 = CubicBezierCurve(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 2.0, y: 1.05), p2: CGPoint(x: 3.0, y: 0.95), p3: CGPoint(x: 4.0, y: 1.0))
        XCTAssert(c3.simple == false)
        // non-simple curve, angle between end point normals > 60 degrees (pi/3) -- in this case the angle is 45 degrees (pi/2)
        let c4 = CubicBezierCurve(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 1.0, y: 2.0), p2: CGPoint(x: 2.0, y: 3.0), p3: CGPoint(x: 3.0, y: 3.0))
        XCTAssert(c4.simple == false)
    }
    
    func testDerivative() {
        let epsilon: CGFloat = 0.00001
        let p0 = CGPoint(x: 1.0, y: 1.0)
        let p1 = CGPoint(x: 3.0, y: 2.0)
        let p2 = CGPoint(x: 5.0, y: 2.0)
        let p3 = CGPoint(x: 7.0, y: 1.0)
        let c = CubicBezierCurve(p0: p0, p1: p1, p2: p2, p3: p3)
        XCTAssert(distance(c.derivative(0.0), 3.0 * (p1 - p0)) < epsilon)
        XCTAssert(distance(c.derivative(0.5), CGPoint(x: 6.0, y: 0.0)) < epsilon)
        XCTAssert(distance(c.derivative(1.0), 3.0 * (p3 - p2)) < epsilon)
    }

    func testSplitFromTo() {
        let epsilon: CGFloat = 0.00001
        let c = CubicBezierCurve(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 3.0, y: 2.0), p2: CGPoint(x: 4.0, y: 2.0), p3: CGPoint(x: 6.0, y: 1.0))
        let t1: CGFloat = 1.0 / 3.0
        let t2: CGFloat = 2.0 / 3.0
        let s = c.split(from: t1, to: t2)
        XCTAssert(BezierKitTestHelpers.curve(s, matchesCurve: c, overInterval: Interval(start: t1,end: t2), tolerance: epsilon))
    }

    func testSplitAt() {
        let epsilon: CGFloat = 0.00001
        let c = CubicBezierCurve(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 3.0, y: 2.0), p2: CGPoint(x: 4.0, y: 2.0), p3: CGPoint(x: 6.0, y: 1.0))
        let t: CGFloat = 0.25
        let (left, right) = c.split(at: t)
        XCTAssert(BezierKitTestHelpers.curve(left, matchesCurve: c, overInterval: Interval(start: 0,end: t), tolerance: epsilon))
        XCTAssert(BezierKitTestHelpers.curve(right, matchesCurve: c, overInterval: Interval(start: t,end: 1), tolerance: epsilon))
    }
    
    func testBoundingBox() {
        // hits codepath where midpoint pushes up y coordinate of bounding box
        let c1 = CubicBezierCurve(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: 3.0, y: 2.0), p2: CGPoint(x: 5.0, y: 2.0), p3: CGPoint(x: 7.0, y: 1.0))
        let expectedBoundingBox1 = BoundingBox(p1: CGPoint(x: 1.0, y: 1.0),
                                              p2: CGPoint(x: 7.0, y: 1.75))
        XCTAssertEqual(c1.boundingBox, expectedBoundingBox1)
        // hits codepath where midpoint pushes down x coordinate of bounding box
        let c2 = CubicBezierCurve(p0: CGPoint(x: 1.0, y: 1.0), p1: CGPoint(x: -3.0, y: 2.0), p2: CGPoint(x: -3.0, y: 3.0), p3: CGPoint(x: 1.0, y: 4.0))
        let expectedBoundingBox2 = BoundingBox(p1: CGPoint(x: -2.0, y: 1.0),
                                               p2: CGPoint(x: 1.0, y: 4.0))
        XCTAssertEqual(c2.boundingBox, expectedBoundingBox2)
        // this one is designed to hit an unusual codepath: c3 has an extrema that would expand the bounding box,
        // but it falls outside of the range 0<=t<=1, and therefore must be excluded
        let c3 = c1.split(at: 0.25).left
        let expectedBoundingBox3 = BoundingBox(p1: CGPoint(x: 1.0, y: 1.0),
                                               p2: CGPoint(x: 2.5, y: 1.5625))
        XCTAssertEqual(c3.boundingBox, expectedBoundingBox3)
        
        // bounding box of a degenerate curve made out of a single point
        let p = CGPoint(x: 1.234, y: 2.394)
        let degenerate = CubicBezierCurve(p0: p, p1: p, p2: p, p3: p)
        XCTAssertEqual(degenerate.boundingBox, BoundingBox(p1: p, p2: p))
    }

    func testCompute() {
        let c = CubicBezierCurve(p0: CGPoint(x: 3.0, y: 5.0),
                                 p1: CGPoint(x: 4.0, y: 6.0),
                                 p2: CGPoint(x: 6.0, y: 6.0),
                                 p3: CGPoint(x: 7.0, y: 5.0))
        XCTAssertEqual(c.compute(0.0), CGPoint(x: 3.0, y: 5.0))
        XCTAssertEqual(c.compute(0.5), CGPoint(x: 5.0, y: 5.75))
        XCTAssertEqual(c.compute(1.0), CGPoint(x: 7.0, y: 5.0))
    }
    
// -- MARK: - methods for which default implementations provided by protocol

    func testLength() {
        let epsilon: CGFloat = 0.00001
        let c1 = CubicBezierCurve(p0: CGPoint(x: 1.0, y: 2.0),
                                  p1: CGPoint(x: 7.0 / 3.0, y: 3.0),
                                  p2: CGPoint(x: 11.0 / 3.0, y: 4.0),
                                  p3: CGPoint(x: 5.0, y: 5.0)
        ) // represents a straight line of length 5 -- most curves won't have an easy reference solution
        XCTAssertEqual(c1.length(), 5.0, accuracy: epsilon)
    }

    func testExtrema() {
        let f: [CGFloat] = [1, -1, 0, 0] // f(t) = t^3 - t^2, which has two local minimum at t=0, t=2/3 and an inflection point t=1/3
        let g: [CGFloat] = [3, -2, 0, 0] // g(t) = 3t^3 - 2t^2, which has a local minimum at t=0, t=4/9 and an inflection point at t=2/9
        let c = BezierKitTestHelpers.cubicBezierCurveFromPolynomials(f, g)
        let (xyz, values) = c.extrema()
        XCTAssert(xyz.count == 2) // one array for each dimension
        XCTAssertEqual(xyz[0].count, 3)
        XCTAssertEqual(xyz[1].count, 3)
        XCTAssertEqual(values.count, 5)
        XCTAssertEqual(values[0], 0.0)
        XCTAssertEqual(values[1], 2.0 / 9.0)
        XCTAssertEqual(values[2], 1.0 / 3.0)
        XCTAssertEqual(values[3], 4.0 / 9.0)
        XCTAssertEqual(values[4], 2.0 / 3.0)
        XCTAssertEqual(xyz[0].count, 3)
        XCTAssertEqual(xyz[0][0], 0.0)
        XCTAssertEqual(xyz[0][1], 1.0 / 3.0)
        XCTAssertEqual(xyz[0][2], 2.0 / 3.0)
        XCTAssertEqual(xyz[1].count, 3)
        XCTAssertEqual(xyz[1][0], 0.0)
        XCTAssertEqual(xyz[1][1], 2.0 / 9.0)
        XCTAssertEqual(xyz[1][2], 4.0 / 9.0)
        // TODO: originally this test used g = [0, 3, -2, 0] but that exposed a flaw in droots because we were passing in a quadratic. We need to fix this in droots
    }
    
// TODO: we still have some missing unit tests for CubicBezierCurve's API entry points
    
//    func testHull() {
//        let l = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 3.0, y: 4.0))
//        let h = l.hull(0.5)
//        XCTAssert(h.count == 3)
//        XCTAssertEqual(h[0], CGPoint(x: 1.0, y: 2.0))
//        XCTAssertEqual(h[1], CGPoint(x: 3.0, y: 4.0))
//        XCTAssertEqual(h[2], CGPoint(x: 2.0, y: 3.0))
//    }
//    
//    func testNormal() {
//        let l = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 5.0, y: 6.0))
//        let n1 = l.normal(0.0)
//        let n2 = l.normal(0.5)
//        let n3 = l.normal(1.0)
//        XCTAssertEqual(n1, CGPoint(x: -1.0 / sqrt(2.0), y: 1.0 / sqrt(2.0)))
//        XCTAssertEqual(n1, n2)
//        XCTAssertEqual(n2, n3)
//    }
//    
//    func testReduce() {
//        let l = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 5.0, y: 6.0))
//        let r = l.reduce() // reduce should just return the original line back
//        XCTAssertEqual(r.count, 1)
//        XCTAssertEqual(r[0].t1, 0.0)
//        XCTAssertEqual(r[0].t2, 1.0)
//        XCTAssertEqual(r[0].curve, l)
//    }
//
//    //    func testScaleDistanceFunc {
//    //
//    //    }
//
//    func testProject() {
//        let l = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 5.0, y: 6.0))
//        let p1 = l.project(point: CGPoint(x: 0.0, y: 0.0)) // should project to p0
//        XCTAssertEqual(p1, CGPoint(x: 1.0, y: 2.0))
//        let p2 = l.project(point: CGPoint(x: 1.0, y: 4.0)) // should project to l.compute(0.25)
//        XCTAssertEqual(p2, CGPoint(x: 2.0, y: 3.0))
//        let p3 = l.project(point: CGPoint(x: 6.0, y: 7.0))
//        XCTAssertEqual(p3, CGPoint(x: 5.0, y: 6.0)) // should project to p1
//    }
//    
//    func testIntersects() {
//        let l = LineSegment(p0: CGPoint(x: 1.0, y: 2.0), p1: CGPoint(x: 5.0, y: 6.0))
//        let i = l.intersects()
//        XCTAssert(i.count == 0) // lines never self-intersect
//    }
//        
//    // -- MARK: - line-curve intersection tests
//    
//    func testIntersectsQuadratic() {
//        // we mostly just care that we call into the proper implementation and that the results are ordered correctly
//        // q is a quadratic where y(x) = 2 - 2(x-1)^2
//        let epsilon: CGFloat = 0.00001
//        let q: QuadraticBezierCurve = QuadraticBezierCurve.init(p0: CGPoint(x: 0.0, y: 0.0),
//                                                                p1: CGPoint(x: 1.0, y: 2.0),
//                                                                p2: CGPoint(x: 2.0, y: 0.0),
//                                                                t: 0.5)
//        let l1: LineSegment = LineSegment(p0: CGPoint(x: -1.0, y: 1.0), p1: CGPoint(x: 3.0, y: 1.0))
//        let l2: LineSegment = LineSegment(p0: CGPoint(x: 3.0, y: 1.0), p1: CGPoint(x: -1.0, y: 1.0)) // same line as l1, but reversed
//        // the intersections for both lines occur at x = 1±sqrt(1/2)
//        let i1 = l1.intersects(curve: q)
//        let r1: CGFloat = 1.0 - sqrt(1.0 / 2.0)
//        let r2: CGFloat = 1.0 + sqrt(1.0 / 2.0)
//        XCTAssertEqual(i1.count, 2)
//        XCTAssertEqualWithAccuracy(i1[0].t1, (r1 + 1.0) / 4.0, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i1[0].t2, r1 / 2.0, accuracy: epsilon)
//        XCTAssert((l1.compute(i1[0].t1) - q.compute(i1[0].t2)).length < epsilon)
//        XCTAssertEqualWithAccuracy(i1[1].t1, (r2 + 1.0) / 4.0, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i1[1].t2, r2 / 2.0, accuracy: epsilon)
//        XCTAssert((l1.compute(i1[1].t1) - q.compute(i1[1].t2)).length < epsilon)
//        // do the same thing as above but using l2
//        let i2 = l2.intersects(curve: q)
//        XCTAssertEqual(i2.count, 2)
//        XCTAssertEqualWithAccuracy(i2[0].t1, (r1 + 1.0) / 4.0, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i2[0].t2, r2 / 2.0, accuracy: epsilon)
//        XCTAssert((l2.compute(i2[0].t1) - q.compute(i2[0].t2)).length < epsilon)
//        XCTAssertEqualWithAccuracy(i2[1].t1, (r2 + 1.0) / 4.0, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i2[1].t2, r1 / 2.0, accuracy: epsilon)
//        XCTAssert((l2.compute(i2[1].t1) - q.compute(i2[1].t2)).length < epsilon)
//    }
//    
//    func testIntersectsCubic() {
//        // we mostly just care that we call into the proper implementation and that the results are ordered correctly
//        let epsilon: CGFloat = 0.00001
//        let c: CubicBezierCurve = CubicBezierCurve(p0: CGPoint(x: -1, y: 0),
//                                                   p1: CGPoint(x: -1, y: 1),
//                                                   p2: CGPoint(x:  1, y: -1),
//                                                   p3: CGPoint(x:  1, y: 0))
//        let l1: LineSegment = LineSegment(p0: CGPoint(x: -2.0, y: 0.0), p1: CGPoint(x: 2.0, y: 0.0))
//        let i1 = l1.intersects(curve: c)
//        
//        XCTAssertEqual(i1.count, 3)
//        XCTAssertEqualWithAccuracy(i1[0].t1, 0.25, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i1[0].t2, 0.0, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i1[1].t1, 0.5, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i1[1].t2, 0.5, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i1[2].t1, 0.75, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i1[2].t2, 1.0, accuracy: epsilon)
//        // l2 is the same line going in the opposite direction
//        // by checking this we ensure the intersections are ordered by the line and not the cubic
//        let l2: LineSegment = LineSegment(p0: CGPoint(x: 2.0, y: 0.0), p1: CGPoint(x: -2.0, y: 0.0))
//        let i2 = l2.intersects(curve: c)
//        XCTAssertEqual(i2.count, 3)
//        XCTAssertEqualWithAccuracy(i2[0].t1, 0.25, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i2[0].t2, 1.0, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i2[1].t1, 0.5, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i2[1].t2, 0.5, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i2[2].t1, 0.75, accuracy: epsilon)
//        XCTAssertEqualWithAccuracy(i2[2].t2, 0.0, accuracy: epsilon)
//    }
//    
    
    func testCubicIntersectsLine() {
        let epsilon: CGFloat = 0.00001
        let c: CubicBezierCurve = CubicBezierCurve(p0: CGPoint(x: -1, y: 0),
                                                   p1: CGPoint(x: -1, y: 1),
                                                   p2: CGPoint(x:  1, y: -1),
                                                   p3: CGPoint(x:  1, y: 0))
        let l: BezierCurve = LineSegment(p0: CGPoint(x: -2.0, y: 0.0), p1: CGPoint(x: 2.0, y: 0.0))
        let i = c.intersections(with: l)
        
        XCTAssertEqual(i.count, 3)
        XCTAssertEqual(i[0].t2, 0.25, accuracy: epsilon)
        XCTAssertEqual(i[0].t1, 0.0, accuracy: epsilon)
        XCTAssertEqual(i[1].t2, 0.5, accuracy: epsilon)
        XCTAssertEqual(i[1].t1, 0.5, accuracy: epsilon)
        XCTAssertEqual(i[2].t2, 0.75, accuracy: epsilon)
        XCTAssertEqual(i[2].t1, 1.0, accuracy: epsilon)
    }

    func testCubicIntersectsLineEdgeCase() {
        // this example caused issues in practice because it has a discriminant that is nearly equal to zero (but not exactly)
        let c = CubicBezierCurve(p0: CGPoint(x: 3, y: 1),
                                 p1: CGPoint(x: 3, y: 1.5522847498307932),
                                 p2: CGPoint(x: 2.5522847498307932, y: 2),
                                 p3: CGPoint(x: 2, y: 2))
        let l = LineSegment(p0: CGPoint(x: 2, y: 2), p1: CGPoint(x: 0, y: 2))
        let i = c.intersections(with: l)
        XCTAssertEqual(i.count, 1)
        XCTAssertEqual(i[0].t1, 1)
        XCTAssertEqual(i[0].t2, 0)
    }
    
    // MARK: -
    
    func testEquatable() {
        let p0 = CGPoint(x: 1.0, y: 2.0)
        let p1 = CGPoint(x: 2.0, y: 3.0)
        let p2 = CGPoint(x: 3.0, y: 3.0)
        let p3 = CGPoint(x: 4.0, y: 2.0)

        let c1 = CubicBezierCurve(p0: p0, p1: p1, p2: p2, p3: p3)
        let c2 = CubicBezierCurve(p0: CGPoint(x: 5.0, y: 6.0), p1: p1, p2: p2, p3: p3)
        let c3 = CubicBezierCurve(p0: p0, p1: CGPoint(x: 1.0, y: 3.0), p2: p2, p3: p3)
        let c4 = CubicBezierCurve(p0: p0, p1: p1, p2: CGPoint(x: 3.0, y: 6.0), p3: p3)
        let c5 = CubicBezierCurve(p0: p0, p1: p1, p2: p2, p3: CGPoint(x: -4.0, y: 2.0))

        XCTAssertEqual(c1, c1)
        XCTAssertNotEqual(c1, c2)
        XCTAssertNotEqual(c1, c3)
        XCTAssertNotEqual(c1, c4)
        XCTAssertNotEqual(c1, c5)
    }
}
